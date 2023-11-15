# frozen_string_literal: true

module Neuronface
  module Activation
    class Sigmoid
      Activations.register_as(:sigmoid, self)

      def forward(net_input)
        @value = 1.0 / (1.0 + Math.exp(-net_input))
      end

      def derivative
        @value * (1 - @value)
      end
    end
  end
end
