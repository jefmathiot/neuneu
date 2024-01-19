# frozen_string_literal: true

require "test_helper"

describe Neuronface::Loss::SquaredError do
  before do
    @loss = Neuronface::Losses.get(:squared_error).new
  end

  it "computes loss for a single example and expected target" do
    _(@loss.loss(3.0, 0)).must_equal 4.5
    _(@loss.loss(3.0, 3.0)).must_equal 0
  end

  it "computes its derivative for a single example and expected target" do
    _(@loss.derivative(3.0, 0)).must_equal 3
    _(@loss.derivative(3.0, 3.0)).must_equal 0
  end

  it "computes the total loss for a set of examples and expected targets" do
    _(@loss.total_loss([3.0, 2.0], [0, 1.0])).must_equal 5
    _(@loss.total_loss([3.0, 2.0], [3.0, 2.0])).must_equal 0
  end
end
