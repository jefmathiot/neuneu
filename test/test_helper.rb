# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "neuronface"

require "minitest/autorun"
require "minitest/spec"

module Neuronface
  module NeuronSpec
    def assign_parameters(neuron, weights, bias)
      neuron.instance_variable_set(:@weights, weights)
      neuron.instance_variable_set(:@bias, bias)
    end
  end
end
