# frozen_string_literal: true

module Neuronface
  module Layers
    class Input
      include Layer

      Layers.register_as(:input, self)

      def initialize(model, index, size, _)
        super(model, index, size)
      end

      def neuron_klazz
        Neurons::Input
      end
    end
  end
end
