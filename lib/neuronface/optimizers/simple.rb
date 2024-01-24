# frozen_string_literal: true

module Neuronface
  module Optimizers
    class Simple
      Optimizers.register_as(:simple, self)

      def initialize(model, opts = {})
        @model = model
        @epochs = opts[:epochs] || 1
        @batch_size = opts[:batch_size]
        @learning_rate = opts[:learning_rate] || 0.5
      end

      def run(dataset)
        with_history do |history|
          @epochs.times do
            losses = perform_epoch(dataset)
            history[:loss] << (losses.inject(:+) / losses.size)
          end
        end
      end

      private

      def perform_epoch(dataset)
        [].tap do |losses|
          dataset.all do |examples|
            examples.each do |example|
              losses << forward(example)
              backward(example)
            end
          end
        end
      end

      def with_history(&block)
        { loss: [] }.tap(&block)
      end

      def total_output_loss(example)
        @model.loss.total_loss(@model.layers.last.neurons.map(&:activation), example.last)
      end

      def forward(example)
        @model.feed(example.first)
        total_output_loss(example)
      end

      def backward(example)
        compute_deltas(example.last)
        adjust_parameters
      end

      def compute_deltas(targets)
        all_layers_but_input.reverse.each { |layer| layer.compute_deltas(targets) }
      end

      def adjust_parameters
        all_layers_but_input.each { |layer| layer.adjust_parameters(@learning_rate) }
      end

      def all_layers_but_input
        @model.layers.drop(1)
      end
    end
  end
end
