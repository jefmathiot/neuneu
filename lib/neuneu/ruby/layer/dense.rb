# frozen_string_literal: true

module Neuneu
  module Ruby
    module Layer
      class Dense < Base
        def initialize(size, index, previous_layer, transfer:, kernel_initializer: nil)
          super(size, index)
          @w_per_neuron = previous_layer.size
          @transfer_function = Builder.transfer(transfer)
          @kernel_initializer = Builder.kernel_initializer(
            **kernel_initializer_opts(kernel_initializer || @transfer_function.default_kernel_initializer)
          )
        end

        def before_training!
          initializer = ->(count) { count.times.map { @kernel_initializer.next } }
          size.times do |neuron|
            @cache.weights_for(index, neuron, initializer.call(@w_per_neuron))
          end
          @cache.biases(index, initializer.call(size))
        end

        def weighted?
          true
        end

        def forward(batch, for_training)
          activations = @cache.activations(index, Array.new(size) { Array.new(batch.first.size) })
          @transfer_function.call(net_inputs(batch), activations, for_training ? @cache.derivatives(index) : nil)
        end

        def adjust_parameters(deltas, activations)
          @biases.each_index { |i| @biases[i] -= deltas[i] }
          size.times do |i| # neuron
            @weights_per_neuron.times do |j| # weight
              @weights[(i * @weights_per_neuron) + j] -= deltas[i] * activations[j]
            end
          end
        end

        private

        def kernel_initializer_opts(initializer)
          { initializer => { fan_in: @w_per_neuron, fan_out: size } }
        end

        def net_inputs(inputs)
          inputs = inputs.transpose
          Array.new(inputs.size) do |i| # index of the sample
            Array.new(size) do |j| # index of the neuron
              Vector.dot(inputs[i], @cache.weights_for(index, j)) + @cache.bias_for(index, j)
            end
          end.transpose
        end
      end
    end
  end
end
