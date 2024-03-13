# frozen_string_literal: true

require "test_helper"

describe Neuneu::Ruby::Builder do
  let(:klazz) { Neuneu::Ruby::Builder }
  let(:previous_layer) { Minitest::Mock.new.expect(:size, 1) }

  it "creates a layer" do
    _(klazz.layer(:input, 0, 1, nil)).wont_be_nil
  end

  it "creates a layer with a transfer function and kernel initializer" do
    _(klazz.layer(:dense, 0, 1, previous_layer, transfer: :sigmoid, kernel_initializer: :he_normal)).wont_be_nil
  end

  it "creates a kernel_initializer" do
    _(klazz.kernel_initializer(:random_normal)).wont_be_nil
  end

  it "creates a kernel_initializer with options" do
    std_deviation = klazz.kernel_initializer(he_normal: { fan_in: 1, fan_out: 1 })
                         .instance_variable_get(:@std_deviation)
    _(std_deviation).must_equal Math.sqrt(2.0)
  end

  it "creates a loss function" do
    _(klazz.loss(:mean_squared_error)).wont_be_nil
  end

  it "creates a transfer function" do
    _(klazz.transfer(:leaky_relu)).wont_be_nil
  end

  it "creates a transfer function with options" do
    _(klazz.transfer(leaky_relu: { negative_slope: 0.5 }).instance_variable_get(:@negative_slope)).must_equal 0.5
  end

  it "creates an optimizer function" do
    _(klazz.optimizer(:sgd)).wont_be_nil
  end

  it "creates an optimizer with options" do
    _(klazz.optimizer(sgd: { momentum: 0.5 }).instance_variable_get(:@momentum)).must_equal 0.5
  end
end
