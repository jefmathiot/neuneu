# frozen_string_literal: true

module Neuronface
  class Model
    attr_reader :layers, :loss

    def initialize(opts)
      @loss = Losses.get(opts[:loss]).new
      @layers = []
    end

    def append(type, neurons, opts = {})
      layer = Layers.get(type).new(self, @layers.size, neurons, opts)
      @layers << layer
      self
    end

    def compile!
      layers.each do |layer|
        layer.respond_to?(:build_parameters) && layer.build_parameters
      end
    end

    def to_h
      { layers: @layers.map(&:to_h) }
    end

    def fit(examples, optimizer, opts)
      compile!
      optimizer = Optimizers.get(optimizer).new(self, opts)
      optimizer.run(examples)
    end

    def feed(inputs)
      layers.first.neurons.each do |neuron|
        neuron.forward(inputs)
      end
      layers.drop(1).each do |layer|
        layer.neurons.each(&:forward)
      end
    end

    def predict(inputs)
      feed(inputs)
      layers.last.neurons.map(&:activation)
    end
  end
end
