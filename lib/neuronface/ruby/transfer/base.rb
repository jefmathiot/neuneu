# frozen_string_literal: true

module Neuronface
  module Ruby
    module Transfer
      class Base
        def call(net_inputs, activations, derivatives)
          net_inputs.each_with_index do |neuron_inputs, i|
            neuron_inputs.each_with_index do |net_input, j|
              value, derivative = activation(net_input, !derivatives.nil?)
              activations[i][j] = value
              derivatives[i] += derivative if derivatives
            end
          end
        end

        def default_kernel_initializer
          raise "Not implemented"
        end

        protected

        def activation(_net_input, _compute_derivative)
          raise "Not implemented"
        end
      end
    end
  end
end
