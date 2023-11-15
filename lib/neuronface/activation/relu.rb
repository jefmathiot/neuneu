# frozen_string_literal: true

module Neuronface
  module Activation
    class ReLU
      Activations.register_as(:relu, self)

      # Leaky ReLU slope for negative inputs
      NEGATIVE_SLOPE = 0.01

      def forward(net_input)
        @value = [0.0, net_input].max + (NEGATIVE_SLOPE * [0.0, net_input].min)
      end

      def derivative
        @value > 0.0 ? 1.0 : NEGATIVE_SLOPE
      end
    end
  end
end
