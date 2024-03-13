# frozen_string_literal: true

require "test_helper"

describe Neuneu::Ruby::Loss::MeanSquaredError do
  let(:loss) { Neuneu::Ruby::Loss::MeanSquaredError.new }
  let(:activations) { [[[0.5, 0.5], [0.5, 0.5]], [[1.0, 1.0], [1.0, 1.0]]] }
  let(:labels) { [[[0.0, 1.0], [1.0, 0.0]], [[2.0, 0.0], [2.0, 0.0]]] }

  it "computes the total loss" do
    loss.accumulate!(activations.first, labels.first, false)
    loss.accumulate!(activations.last, labels.last, false)
    _(loss.total_loss).must_equal 5.0
    _(loss.finalize!.total_loss).must_equal 0.5 * 5.0 / 8
    _(loss.derivatives).must_be_nil
  end

  it "computes the derivatives of the loss function" do
    loss.accumulate!(activations.first, labels.first, true)
    loss.accumulate!(activations.last, labels.last, true)
    _(loss.derivatives).must_equal [-1.0, 1.0]
  end
end
