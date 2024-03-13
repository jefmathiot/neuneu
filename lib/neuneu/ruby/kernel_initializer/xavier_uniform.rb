# frozen_string_literal: true

module Neuneu
  module Ruby
    module KernelInitializer
      class XavierUniform
        def initialize(fan_in:, fan_out:)
          divisor = Math.sqrt(fan_in + fan_out)
          @weights_lbound = -(Math.sqrt(6.0) / divisor)
          @weights_ubound = Math.sqrt(6.0) / divisor
        end

        def next
          @weights_lbound + (rand * (@weights_ubound - @weights_lbound))
        end
      end
    end
  end
end
