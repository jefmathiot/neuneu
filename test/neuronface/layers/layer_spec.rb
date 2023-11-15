# frozen_string_literal: true

require "test_helper"

class TestDoubleLayer
  include Neuronface::Layers::Layer

  def neuron_klazz
    Neuronface::Neurons::Neuron
  end
end

describe Neuronface::Layers::Layer do
  before do
    @model = Minitest::Mock.new
  end

  it "identifies" do
    layer = TestDoubleLayer.new(@model, 0, 2)
    _(layer.name).must_equal "TestDoubleLayer_0"
    _(layer.index).must_equal 0
  end

  it "creates neurons according to dimensionality" do
    layer = TestDoubleLayer.new(@model, 0, 10)
    _(layer.neurons.size).must_equal 10
    _(layer.neurons.first.class).must_equal Neuronface::Neurons::Neuron
  end

  describe "accessing sibling layers in the network" do
    before do
      @layers = [TestDoubleLayer.new(@model, 0, 2), TestDoubleLayer.new(@model, 1, 2)]
      2.times { @model.expect(:layers, @layers) }
    end

    it "provides the previous layer in the network" do
      _(@layers.last.previous_layer).must_equal @layers.first
    end

    it "provides the next layer in the network" do
      _(@layers.first.next_layer).must_equal @layers.last
    end

    it "it indicates whether it is an output layer" do
      _(@layers.first.output_layer?).must_equal false
      _(@layers.last.output_layer?).must_equal true
    end
  end

  it "serializes to a hash" do
    hash = TestDoubleLayer.new(@model, 0, 2).to_h
    _(hash[:name]).must_equal "TestDoubleLayer_0"
    _(hash[:neurons].size).must_equal 2
    _(hash[:neurons].first[:name]).must_equal "TestDoubleLayer_0_0"
  end
end
