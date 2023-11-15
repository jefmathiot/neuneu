# frozen_string_literal: true

require "neuronface/identified"

module Neuronface
  module Layers
    module Layer
      include Neuronface::Identified

      attr_reader :dimensionality, :neurons

      def initialize(model, index, size)
        @dimensionality = size
        @model = model
        identify(index, self.class.name)
        @neurons = []
        size.times do
          @neurons << neuron_klazz.new(self, @neurons.size).tap do |neuron|
            neuron.identify(@neurons.size, name)
          end
        end
      end

      def to_h
        { name: name, neurons: neurons.map(&:to_h) }
      end

      def previous_layer
        @model.layers[index - 1]
      end

      def next_layer
        @model.layers[index + 1]
      end

      def output_layer?
        next_layer.nil?
      end
    end
  end
end
