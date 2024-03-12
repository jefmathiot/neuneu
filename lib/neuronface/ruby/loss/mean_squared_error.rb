# frozen_string_literal: true

module Neuronface
  module Ruby
    module Loss
      class MeanSquaredError
        attr_reader :total_loss, :derivatives

        def initialize
          @total_loss = 0.0
          @count = 0
        end

        def accumulate!(activations, labels, for_training)
          @derivatives = Array.new(activations.first.size) if for_training
          @count += activations.size * activations.first.size
          compute_loss(activations, labels, for_training)
        end

        def finalize!
          @total_loss = 0.5 * @total_loss / @count
          self
        end

        private

        def compute_loss(activations, labels, for_training)
          expected = labels.transpose
          activations.each_with_index do |neuron_activations, neuron|
            @total_loss += Vector.square(Vector.substract(expected[neuron], neuron_activations)).sum
            @derivatives[neuron] = Vector.mean(Vector.substract(neuron_activations, expected[neuron])) if for_training
          end
        end
      end
    end
  end
end
