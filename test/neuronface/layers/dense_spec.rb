# frozen_string_literal: true

require "test_helper"

describe Neuronface::Layers::Dense do
  before do
    @model = Minitest::Mock.new
    @activation = Object.new
    Neuronface::Activations.register_as(:test_activation, @activation)
    @layer = Neuronface::Layers.get(:dense).new(@model, 1, 2, { activation: :test_activation })
  end

  it "provides access to the activation functor" do
    _(@layer.activation).must_equal @activation
  end

  it "creates regular neurons" do
    _(@layer.neurons.size).must_equal(2)
    _(@layer.neurons.first.class).must_equal Neuronface::Neurons::Neuron
  end

  it "builds parameters based on previous layer dimensionality" do
    previous_layer = Minitest::Mock.new
    previous_layer.expect(:dimensionality, 8)
    @model.expect(:layers, [previous_layer, @layer])
    @layer.build_parameters
    _(@layer.neurons.first.weights.size).must_equal 8
    _(@layer.neurons.last.weights.size).must_equal 8
  end
end
