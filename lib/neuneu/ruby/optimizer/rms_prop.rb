# frozen_string_literal: true

module Neuneu
  module Ruby
    module Optimizer
      class RmsProp < Base
        def initialize(learning_rate: 0.001, rho: 0.9, epsilon: 1e-7)
          super()
          @learning_rate = learning_rate
          @rho = rho
          @epsilon = epsilon
          @velocity = []
        end

        protected

        def compute_updates(layer, deltas)
          compute_velocity(layer, deltas)
          @velocity[layer.index].map.with_index { |v, i| (@learning_rate / (Math.sqrt(v) + @epsilon)) * deltas[i] }
        end

        private

        def compute_velocity(layer, deltas)
          @velocity[layer.index] ||= Array.new(deltas.size) { 0.0 }
          @velocity[layer.index] = @velocity[layer.index].map.with_index do |v, i|
            (@rho * v) + ((1 - @rho) * (deltas[i]**2))
          end
        end
      end
    end
  end
end
