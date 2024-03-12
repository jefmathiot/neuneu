# frozen_string_literal: true

#  frozen_string_literal: true

module Neuronface
  module Ruby
    module Cache
      class Training < FeedForward
        attr_reader :history

        def initialize(layers)
          super(layers)
          @deltas = layers.map { |layer| Array.new(layer.size) }
          @derivatives = layers.map { |layer| Array.new(layer.size) { 0.0 } }
        end

        def derivatives(layer, value = nil)
          return @derivatives[layer] = value if value

          @derivatives[layer]
        end

        def deltas(layer, value = nil)
          return @deltas[layer] = value if value

          @deltas[layer]
        end

        def reset!
          @derivatives.each { |derivatives| derivatives.each_index { |i| derivatives[i] = 0.0 } }
        end

        def average_derivatives!(size)
          @derivatives = @derivatives.map { |derivatives| Vector.divide(derivatives, size) }
        end
      end
    end
  end
end
