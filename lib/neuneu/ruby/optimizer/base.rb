# frozen_string_literal: true

#  frozen_string_literal: true

module Neuneu
  module Ruby
    module Optimizer
      class Base
        def adjust_parameters(layers, cache)
          layers.select(&:weighted?).each do |layer|
            apply_parameters_update(
              layer, cache,
              compute_updates(layer, cache.deltas(layer.index)),
              average_activations(cache.activations(layer.index - 1))
            )
          end
        end

        private

        def apply_parameters_update(layer, cache, updates, activations)
          cache.biases(layer.index, Vector.substract(cache.biases(layer.index), updates))
          layer.size.times do |i| # neuron
            weights = cache.weights_for(layer.index, i)
            cache.weights_for(layer.index, i, Vector.substract(weights, Vector.multiply(activations, updates[i])))
          end
        end

        def average_activations(activations)
          activations.map { |n_activations| Vector.mean(n_activations) }
        end
      end
    end
  end
end
