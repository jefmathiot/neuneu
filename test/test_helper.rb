# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "simplecov"
SimpleCov.start

require "neuneu"

require "minitest/autorun"
require "minitest/spec"

module Neuneu
  module NeuronSpec
    def assign_parameters(neuron, weights, bias)
      neuron.instance_variable_set(:@weights, weights)
      neuron.instance_variable_set(:@bias, bias)
    end
  end
end
