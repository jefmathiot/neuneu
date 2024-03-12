# frozen_string_literal: true

module Neuronface
  module Ruby
    class Backend
      attr_reader :layers, :cache, :history

      def initialize
        @layers = []
        @history = History.new
      end

      def append(type, size = 0, **kwargs)
        @layers << Builder.layer(type, size, @layers.size, @layers.last, **kwargs)
      end

      def fit(dataset, loss:, epochs: 1, batch_size: 1, optimizer: :sgd)
        build_cache
        before_training!
        BackPropagator.new(self, optimizer).run(dataset, epochs, batch_size, loss)
        @history
      end

      def forward(features, for_training)
        @layers.first.forward(features)
        active_layers.each do |layer|
          layer.forward(cache.activations(layer.index - 1), for_training)
        end
      end

      def predict(features)
        forward(features, false)
        cache.activations(layers.last.index)
      end

      def output_layer
        layers.last
      end

      def hidden_layers
        active_layers.reverse.drop(1)
      end

      def active_layers
        @layers.drop(1)
      end

      private

      def build_cache
        @cache = Cache::Training.new(layers)
      end

      def before_training!
        layers.each do |layer|
          layer.assign_cache(@cache)
          layer.before_training!
        end
      end
    end
  end
end
