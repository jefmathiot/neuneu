# frozen_string_literal: true

require "test_helper"

describe Neuronface::Activation::ReLU do
  before do
    @relu = Neuronface::Activations.get(:relu).new
  end

  it "computes a negative value" do
    _(@relu.forward(-2)).must_equal(-0.02)
    _(@relu.derivative).must_equal(0.01)
  end

  it "computes zero" do
    _(@relu.forward(0.0)).must_equal 0.0
    _(@relu.derivative).must_equal(0.01)
  end

  it "computes a positive value" do
    _(@relu.forward(1.0)).must_equal 1.0
    _(@relu.derivative).must_equal(1.0)
  end
end
