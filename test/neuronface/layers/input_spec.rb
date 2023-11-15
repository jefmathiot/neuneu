# frozen_string_literal: true

require "test_helper"

describe Neuronface::Layers::Input do
  before do
    @model = Minitest::Mock.new
  end

  it "creates input neurons" do
    layer = Neuronface::Layers.get(:input).new(@model, 0, 2, {})
    _(layer.neurons.size).must_equal(2)
    _(layer.neurons.first.class).must_equal Neuronface::Neurons::Input
  end
end
