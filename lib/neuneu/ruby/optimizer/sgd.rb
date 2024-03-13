# frozen_string_literal: true

#  frozen_string_literal: true

module Neuneu
  module Ruby
    module Optimizer
      class Sgd < Base
        def initialize(learning_rate: 0.5, momentum: 0.0)
          super()
          @learning_rate = learning_rate
          @momentum = momentum
          @velocity = []
        end

        protected

        def compute_updates(layer, deltas)
          if @momentum.zero?
            Vector.multiply(deltas, @learning_rate)
          else
            compute_velocity(layer, deltas)
          end
        end

        private

        def compute_velocity(layer, deltas)
          @velocity[layer.index] ||= Array.new(deltas.size) { 0.0 }
          @velocity[layer.index] = @velocity[layer.index].map.with_index do |v, i|
            (deltas[i] * @learning_rate) - (v * @momentum)
          end
        end
      end
    end
  end
end
