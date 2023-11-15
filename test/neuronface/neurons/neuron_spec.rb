# frozen_string_literal: true

require "test_helper"

describe Neuronface::Neurons::Neuron do
  include Neuronface::NeuronSpec

  before do
    @layer = Minitest::Mock.new
    @layer.expect(:name, "layer_0")
    @neuron = Neuronface::Neurons::Neuron.new(@layer, 0)
    @layer.verify
  end

  it "identifies as a neuron belonging to a layer" do
    _(@neuron.name).must_equal "layer_0_0"
    _(@neuron.index).must_equal 0
  end

  it "creates parameters depending on dimensionality and randomizes them" do
    @neuron.build_parameters(2)
    _(@neuron.weights.size).must_equal 2
    @neuron.weights.each do |weight|
      _(weight).must_be_close_to 0, 1
    end
    _(@neuron.bias).must_be_close_to 0, 1
  end

  it "serializes to a hash" do
    assign_parameters(@neuron, [0.1, 0.2], 0.5)
    hash = @neuron.to_h
    _(hash[:name]).must_equal "layer_0_0"
    _(hash[:weights]).must_equal [0.1, 0.2]
    _(hash[:bias]).must_equal 0.5
  end

  it "forwards net input to the activation function" do
    previous_layer = Minitest::Mock.new
    previous_neurons = [Minitest::Mock.new, Minitest::Mock.new]
    previous_neurons.each { |neuron| neuron.expect(:activation, 0.5) }
    previous_layer.expect(:neurons, previous_neurons)
    assign_parameters(@neuron, [0.1, 0.2], 0.3)
    @layer.expect(:previous_layer, previous_layer)
    functor = Minitest::Mock.new.expect(:new, Minitest::Mock.new.expect(:forward, 0.8, [0.45]))
    @layer.expect(:activation, functor)
    @neuron.forward
    _(@neuron.activation).must_equal 0.8
  end

  describe "computing delta" do
    before do
      activation_functor = Minitest::Mock.new.expect(:derivative, 0.5)
      @neuron.instance_variable_set(:@activation_function, activation_functor)
    end

    it "uses loss at the output layer" do
      @neuron.instance_variable_set(:@activation, 1.0)
      loss_functor = Minitest::Mock.new.expect(:derivative, 0.6, [1.0, 0.1])
      @layer.expect(:output_layer?, true)
      @neuron.compute_delta([0.1, 0.2], loss_functor)
      _(@neuron.delta).must_equal 0.3
    end

    it "uses deltas from the next layer for hidden layers" do
      next_layer = Minitest::Mock.new
      next_neurons = [
        Minitest::Mock.new.expect(:delta, 0.1).expect(:weights, [0.2]),
        Minitest::Mock.new.expect(:delta, 0.3).expect(:weights, [0.4])
      ]
      @layer.expect(:output_layer?, false)
      @layer.expect(:next_layer, next_layer.expect(:neurons, next_neurons))
      @neuron.compute_delta(nil, nil)
      _(@neuron.delta).must_equal 0.07
    end
  end

  it "adjusts parameters according to delta" do
    previous_layer = Minitest::Mock.new
    previous_neurons = [Minitest::Mock.new, Minitest::Mock.new]
    previous_neurons.first.expect(:activation, 0.3)
    previous_neurons.last.expect(:activation, 0.4)
    2.times do
      @layer.expect(:previous_layer, previous_layer)
      previous_layer.expect(:neurons, previous_neurons)
    end
    assign_parameters(@neuron, [0.1, 0.2], 0.5)
    @neuron.instance_variable_set(:@delta, 0.1)
    @neuron.adjust_parameters(0.05)
    _(@neuron.weights.first).must_equal 0.0985
    _(@neuron.weights.last).must_equal 0.198
    _(@neuron.bias).must_equal 0.495
  end
end
