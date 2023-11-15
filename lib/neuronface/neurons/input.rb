# frozen_string_literal: true

module Neuronface
  module Neurons
    class Input < Neuron
      def forward(inputs)
        @activation = @net_input = inputs[index]
      end
    end
  end
end
