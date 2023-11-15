# frozen_string_literal: true

require "test_helper"

describe Neuronface::Activation::Sigmoid do
  before do
    @sigmoid = Neuronface::Activations.get(:sigmoid).new
  end

  it "computes a negative value" do
    _(@sigmoid.forward(-1.0)).must_equal(0.2689414213699951)
    _(@sigmoid.derivative).must_equal(0.19661193324148185)
  end

  it "computes zero" do
    _(@sigmoid.forward(0.0)).must_equal 0.5
    _(@sigmoid.derivative).must_equal(0.25)
  end

  it "computes a positive value" do
    _(@sigmoid.forward(1.0)).must_equal 0.7310585786300049
    _(@sigmoid.derivative).must_equal 0.19661193324148185
  end
end
