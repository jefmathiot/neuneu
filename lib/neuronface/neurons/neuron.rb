# frozen_string_literal: true

require "neuronface/identified"
require "neuronface/vector"

module Neuronface
  module Neurons
    class Neuron
      include Identified

      attr_reader :layer, :net_input, :activation, :activation_function, :delta, :weights, :bias

      def initialize(layer, index)
        @layer = layer
        identify(index, layer.name)
      end

      def build_parameters(dimensionality)
        @weights = Array.new(dimensionality) { rand }
        @bias = rand
      end

      def to_h
        %i[name weights bias].each_with_object({}) { |key, hash| hash[key] = send(key) }
      end

      def forward
        @net_input = Vector.dot(layer.previous_layer.neurons.map(&:activation), weights) + bias
        @activation_function = layer.activation.new
        @activation = @activation_function.forward(@net_input)
      end

      def compute_delta(targets, loss_function)
        @delta = layer.output_layer? ? delta_from_loss(targets, loss_function) : delta_from_next_layer
      end

      def adjust_parameters(learning_rate)
        @weights = @weights.map.with_index do |weight, weight_index|
          weight - (learning_rate * delta * layer.previous_layer.neurons[weight_index].activation)
        end
        @bias -= learning_rate * delta
      end

      private

      def delta_from_next_layer
        activation_function.derivative *
          layer.next_layer.neurons
               .map { |neuron| neuron.delta * neuron.weights[index] }
               .sum(0.0)
      end

      def delta_from_loss(targets, loss_function)
        activation_function.derivative * loss_function.derivative(activation, targets[index])
      end
    end
  end
end
