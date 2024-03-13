# frozen_string_literal: true

require "test_helper"

describe Neuneu::Ruby::Optimizer::Adam do
  let(:klazz) { Neuneu::Ruby::Optimizer::Adam }
  let(:layers) do
    [
      l0 = Neuneu::Ruby::Layer::Input.new(2, 0, nil),
      l1 = Neuneu::Ruby::Layer::Dense.new(2, 1, l0, transfer: :sigmoid),
      l2 = Neuneu::Ruby::Layer::Dropout.new(nil, 2, l1),
      Neuneu::Ruby::Layer::Dense.new(2, 3, l2, transfer: :sigmoid)
    ]
  end
  let(:cache) { Neuneu::Ruby::Cache::Training.new(layers) }

  before do
    cache.activations(0, [[1.0, 1.0], [1.0, 1.0]])
    cache.activations(1, [[1.0, 1.0], [1.0, 1.0]])
    cache.activations(2, [[1.0, 1.0], [1.0, 1.0]])
    cache.activations(3, [[1.0, 1.0], [1.0, 1.0]])
    cache.biases(1, [0.1, 0.2])
    cache.biases(3, [0.3, 0.4])
    cache.weights(1, [[0.5], [1.0]])
    cache.weights(3, [[2.0, 3.0], [4.0, 5.0]])
    cache.deltas(1, [0.25, 0.25])
    cache.deltas(3, [0.5, 0.5])
  end

  it "adjust parameters" do
    optimizer = klazz.new
    optimizer.adjust_parameters(layers, cache)
    _(cache.weights(1)).must_equal [[0.49900000039999987], [0.9990000003999998]]
    _(cache.weights(3)).must_equal [[1.9990000002, 2.9990000002], [3.9990000002, 4.9990000002]]
    optimizer.adjust_parameters(layers, cache)
    _(cache.weights(1)).must_equal [[0.49765616189420847], [0.9976561618942084]]
    _(cache.weights(3)).must_equal [[1.9976561615041135, 2.9976561615041137], [3.9976561615041137, 4.997656161504113]]
  end

  it "adjust parameters with learning rate, beta1 and beta2" do
    optimizer = klazz.new(learning_rate: 0.005, beta1: 0.5, beta2: 0.8)
    optimizer.adjust_parameters(layers, cache)
    _(cache.weights(1)).must_equal [[0.4950000019999992], [0.9950000019999992]]
    _(cache.weights(3)).must_equal [[1.9950000009999997, 2.9950000009999997], [3.9950000009999997, 4.995000001]]
    optimizer.adjust_parameters(layers, cache)
    _(cache.weights(1)).must_equal [[0.4894098337229159], [0.9894098337229159]]
    _(cache.weights(3)).must_equal [[1.9894098318895834, 2.9894098318895836], [3.9894098318895836, 4.989409831889584]]
  end
end
