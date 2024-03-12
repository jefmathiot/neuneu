# frozen_string_literal: true

module Neuronface
  module Ruby
    module Layer
      class Dropout < Base
        def initialize(_, index, previous_layer, rate: 0.1)
          super(previous_layer.size, index)
          @rate = rate
          @mask = 1.0 / (1.0 - @rate)
        end

        def forward(batch, for_training)
          if for_training
            masks = batch.first.size.times.map { bernoulli }.transpose
            training_forward(batch, masks)
          else
            @cache.activations(index, Array.new(size) { |i| batch[i].dup })
          end
        end

        private

        def training_forward(batch, masks)
          @cache.activations(index, Array.new(size) { |i| Vector.multiply(batch[i], masks[i]) })
          @cache.derivatives(index, Array.new(size) { |i| masks[i].sum })
        end

        def bernoulli
          size.times.map { rand < @rate ? 0.0 : @mask }
        end
      end
    end
  end
end
