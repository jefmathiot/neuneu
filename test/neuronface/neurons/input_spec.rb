# frozen_string_literal: true

require "test_helper"

describe Neuronface::Neurons::Input do
  it "forwards inputs using the identify function" do
    layer = Minitest::Mock.new.expect(:name, "layer_0")
    neuron = Neuronface::Neurons::Input.new(layer, 1)
    neuron.forward([0.1, 0.2])
    _(neuron.activation).must_equal 0.2
    _(neuron.net_input).must_equal 0.2
  end
end
