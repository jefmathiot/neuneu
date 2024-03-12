# frozen_string_literal: true

require "forwardable"

module Neuronface
  module Ruby
    class BackPropagator
      extend Forwardable

      attr_reader :backend

      def_delegators :@backend, :layers, :active_layers, :hidden_layers, :output_layer, :cache, :history

      def initialize(backend, optimizer: :vanilla)
        @backend = backend
        @optimizer = Builder.optimizer(optimizer)
      end

      def run(dataset, epochs, batch_size, loss)
        epochs.times do |_epoch|
          accumulator = epoch(dataset, batch_size, loss)
          history.append :training, accumulator.finalize!.total_loss
        end
        history
      end

      private

      def epoch(dataset, batch_size, loss)
        Builder.loss(loss).tap do |accumulator|
          dataset.batch(batch_size) do |features, labels|
            forward(features)
            cache.average_derivatives!(features.size)
            accumulator.accumulate!(cache.activations(layers.last.index), labels, true)
            backpropagate(accumulator)
          end
        end
      end

      def forward(features)
        cache.reset!
        backend.forward(features, true)
      end

      def backpropagate(accumulator)
        deltas_from_loss(accumulator)
        # hidden_layers expose last layers first
        hidden_layers.each do |layer|
          deltas_from_next_layer(layer, layers[layer.index + 1])
        end
        @optimizer.adjust_parameters(active_layers, cache)
      end

      def deltas_from_loss(accumulator)
        cache.deltas(layers.last.index, Vector.multiply(cache.derivatives(layers.last.index), accumulator.derivatives))
      end

      def deltas_from_next_layer(layer, next_layer)
        cache.deltas(
          layer.index,
          Vector.multiply(cache.derivatives(layer.index), weighted_deltas(layer, next_layer))
        )
      end

      def weighted_deltas(layer, next_layer)
        if next_layer.weighted?
          layer.size.times.map do |neuron|
            Vector.multiply(cache.deltas(next_layer.index), cache.weights_from(next_layer.index, neuron)).sum(0.0)
          end
        else
          # For layers without weights, such as dropout layers
          cache.deltas(next_layer.index)
        end
      end
    end
  end
end
