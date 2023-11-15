# frozen_string_literal: true

module Neuronface
  module Optimizers
    class Simple
      Optimizers.register_as(:simple, self)

      def initialize(model, opts)
        @model = model
        @epochs = opts[:epochs] || 1
        @learning_rate = opts[:learning_rate] || 0.5
      end

      def run(examples)
        { loss: [] }.tap do |history|
          @epochs.times do
            losses = []
            examples.each do |example|
              losses << forward(example)
              backward(example.last)
            end
            history[:loss] << (losses.inject(:+) / losses.size)
          end
        end
      end

      private

      def total_output_loss(example)
        @model.loss.total_loss(@model.layers.last.neurons.map(&:activation), example.last)
      end

      def forward(example)
        @model.feed(example.first)
        total_output_loss(example)
      end

      def backward(targets)
        compute_deltas(targets)
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
