# frozen_string_literal: true

module Neuronface
  module Loss
    class SquaredError
      Losses.register_as(:squared_error, self)

      def total_loss(outputs, targets)
        outputs.map.with_index { |output, i| loss(output, targets[i]) }.inject(:+)
      end

      def loss(output, target)
        0.5 * ((target - output)**2)
      end

      def derivative(output, target)
        output - target
      end
    end
  end
end
