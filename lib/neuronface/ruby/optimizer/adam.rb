# frozen_string_literal: true

module Neuronface
  module Ruby
    module Optimizer
      class Adam < Base
        def initialize(learning_rate: 0.001, beta1: 0.9, beta2: 0.999, epsilon: 1e-7)
          super()
          @learning_rate = learning_rate
          @beta1 = beta1
          @beta2 = beta2
          @epsilon = epsilon
          @momentum = []
          @velocity = []
        end

        protected

        def compute_updates(layer, deltas)
          compute_momentum(layer, deltas)
          compute_velocity(layer, deltas)
          @velocity[layer.index].map.with_index do |vt, i|
            compute_update(@momentum[layer.index][i], vt)
          end
        end

        private

        def compute_update(momentum, velocity)
          @learning_rate * (momentum / (1 - @beta1)) / (Math.sqrt(velocity / (1 - @beta2)) + @epsilon)
        end

        def compute_velocity(layer, deltas)
          compute_component(layer, deltas, @velocity, @beta2) { |delta| delta**2 }
        end

        def compute_momentum(layer, deltas)
          compute_component(layer, deltas, @momentum, @beta1) { |delta| delta }
        end

        def compute_component(layer, deltas, collection, beta)
          collection[layer.index] ||= Array.new(deltas.size) { 0.0 }
          collection[layer.index] = collection[layer.index].map.with_index do |v, i|
            (beta * v) + ((1 - beta) * yield(deltas[i]))
          end
        end
      end
    end
  end
end
