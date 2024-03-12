# frozen_string_literal: true

module Neuronface
  module Ruby
    module KernelInitializer
      class RandomNormal
        def initialize(mean:, std_deviation:)
          @mean = mean
          @std_deviation = std_deviation
          @value_swap = false
        end

        def next
          if @value_swap
            @value_swap = false
            @next_number
          else
            @value_swap = true
            x, y = gaussian(@mean, @std_deviation)
            @next_number = y
            x
          end
        end

        private

        # Box-Muller transform
        def gaussian(mean, std_deviation)
          theta = 2 * Math::PI * rand
          rho = Math.sqrt(-2 * Math.log(1 - rand))
          scale = std_deviation * rho
          x = mean + (scale * Math.cos(theta))
          y = mean + (scale * Math.sin(theta))
          [x, y]
        end
      end
    end
  end
end
