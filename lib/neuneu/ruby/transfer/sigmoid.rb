# frozen_string_literal: true

module Neuneu
  module Ruby
    module Transfer
      class Sigmoid < Base
        def activation(net_input, compute_derivative)
          value = 1.0 / (1.0 + Math.exp(-net_input))
          [value, compute_derivative ? value * (1 - value) : nil]
        end

        def default_kernel_initializer
          :xavier_uniform
        end
      end
    end
  end
end
