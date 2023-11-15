# frozen_string_literal: true

module Neuronface
  module Layers
    class Dense
      include Layer

      Layers.register_as(:dense, self)

      attr_reader :activation

      def initialize(model, index, size, opts = {})
        super(model, index, size)
        @activation = Activations.get(opts[:activation])
      end

      def neuron_klazz
        Neurons::Neuron
      end

      def build_parameters
        dimensionality = previous_layer.dimensionality
        @neurons.each { |neuron| neuron.build_parameters(dimensionality) }
      end

      def compute_deltas(targets)
        neurons.each do |neuron|
          neuron.compute_delta(targets, @model.loss)
        end
      end

      def adjust_parameters(learning_rate)
        neurons.each { |neuron| neuron.adjust_parameters(learning_rate) }
      end
    end
  end
end
