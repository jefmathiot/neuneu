# frozen_string_literal: true

require "test_helper"

describe Neuneu::Ruby::Transfer::LeakyRelu do
  let(:transfer) { Neuneu::Ruby::Transfer::LeakyRelu.new }
  let(:net_inputs) { [[1.0, -1.0], [2.0, -2.0]] }
  let(:activations) { [[], []] }
  let(:derivatives) { [0.0, 0.0] }

  it "defaults the kernel initializer to He Normal" do
    _(transfer.default_kernel_initializer).must_equal :he_normal
  end

  it "transfer net inputs to the activations" do
    transfer.call(net_inputs, activations, nil)
    _(activations).must_equal [[1.0, -0.01], [2.0, -0.02]]
  end

  it "computes derivatives" do
    transfer.call(net_inputs, activations, derivatives)
    _(derivatives).must_equal [1.01, 1.01]
  end
end
