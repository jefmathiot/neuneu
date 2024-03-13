# frozen_string_literal: true

require "test_helper"

describe Neuneu::Ruby::Optimizer::Sgd do
  let(:klazz) { Neuneu::Ruby::Optimizer::Sgd }
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
    _(cache.weights(1)).must_equal [[0.375], [0.875]]
    _(cache.weights(3)).must_equal [[1.75, 2.75], [3.75, 4.75]]
    optimizer.adjust_parameters(layers, cache)
    _(cache.weights(1)).must_equal [[0.25], [0.75]]
    _(cache.weights(3)).must_equal [[1.5, 2.5], [3.5, 4.5]]
  end

  it "adjust parameters with momentum" do
    optimizer = klazz.new(momentum: 0.1)
    optimizer.adjust_parameters(layers, cache)
    _(cache.weights(1)).must_equal [[0.375], [0.875]]
    _(cache.weights(3)).must_equal [[1.75, 2.75], [3.75, 4.75]]
    optimizer.adjust_parameters(layers, cache)
    _(cache.weights(1)).must_equal [[0.2625], [0.7625]]
    _(cache.weights(3)).must_equal [[1.525, 2.525], [3.525, 4.525]]
  end
end
