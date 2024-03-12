# frozen_string_literal: true

module Neuronface
  module Ruby
    module KernelInitializer
      class HeNormal < RandomNormal
        # rubocop:disable Lint/UnusedMethodArgument
        def initialize(fan_in:, fan_out:)
          super(mean: 0, std_deviation: Math.sqrt(2.0 / fan_in))
        end
        # rubocop:enable Lint/UnusedMethodArgument
      end
    end
  end
end
