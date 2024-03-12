# frozen_string_literal: true

require "test_helper"

describe Neuronface::Ruby::Transfer::Sigmoid do
  let(:transfer) { Neuronface::Ruby::Transfer::Sigmoid.new }
  let(:net_inputs) { [[0.0, 1.0], [0.0, -2.0]] }
  let(:activations) { [[], []] }
  let(:derivatives) { [0.0, 0.0] }

  it "defaults the kernel initializer to Xavier Uniform" do
    _(transfer.default_kernel_initializer).must_equal :xavier_uniform
  end

  it "transfer net inputs to the activations" do
    transfer.call(net_inputs, activations, nil)
    _(activations).must_equal [[0.5, 0.7310585786300049], [0.5, 0.11920292202211755]]
  end

  it "computes derivatives" do
    transfer.call(net_inputs, activations, derivatives)
    _(derivatives).must_equal [0.44661193324148185, 0.3549935854035065]
  end
end
