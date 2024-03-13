# frozen_string_literal: true

module Neuneu
  module Ruby
    module Transfer
      class LeakyRelu < Base
        # - negative_slope: Leaky ReLU slope for negative inputs
        def initialize(negative_slope: 0.01)
          super()
          @negative_slope = negative_slope
        end

        def default_kernel_initializer
          :he_normal
        end

        protected

        def activation(net_input, compute_derivative)
          value = [0.0, net_input].max + (@negative_slope * [0.0, net_input].min)
          [value, (compute_derivative && (value > 0.0 ? 1.0 : @negative_slope)) || nil]
        end
      end
    end
  end
end
