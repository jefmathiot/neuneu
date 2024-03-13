# frozen_string_literal: true

#  frozen_string_literal: true

module Neuneu
  module Ruby
    module Cache
      class FeedForward
        def initialize(layers)
          @activations = layers.map { |layer| Array.new(layer.size) }
          initialize_parameters(layers)
        end

        def activations(layer, value = nil)
          return @activations[layer] = value if value

          @activations[layer]
        end

        def derivatives(_); end

        def biases(layer, value = nil)
          return @biases[layer] = value if value

          @biases[layer]
        end

        def bias_for(layer, neuron, value = nil)
          return @biases[layer][neuron] = value if value

          @biases.dig(layer, neuron)
        end

        def weights_for(layer, neuron, value = nil)
          return @weights[layer][neuron] = value if value

          @weights.dig(layer, neuron)
        end

        def weights_from(layer, neuron)
          @weights[layer].transpose[neuron]
        end

        def reset!; end

        def average_derivatives!(size); end

        private

        def initialize_parameters(layers)
          @biases = layers.map { |layer| Array.new(layer.size) }
          @weights = layers.map.with_index do |layer, _i|
            Array.new(layer.size) { Array.new(layers[layer.index - 1].size) } if layer.weighted?
          end
        end
      end
    end
  end
end
