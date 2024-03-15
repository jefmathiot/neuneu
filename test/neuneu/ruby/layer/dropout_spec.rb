# frozen_string_literal: true

require "test_helper"

describe Neuneu::Ruby::Layer::Dropout do
  let(:previous_layer) { Neuneu::Ruby::Layer::Input.new(20, 0, nil) }
  let(:layer) { Neuneu::Ruby::Layer::Dropout.new(nil, 1, previous_layer, rate: 0.2) }
  let(:cache) { Neuneu::Ruby::Cache::Training.new([previous_layer, layer]) }
  let(:inputs) { [[1.0, 2.0]] * 20 }

  it "initializes with the default dropout rate" do
    layer = Neuneu::Ruby::Layer::Dropout.new(nil, 1, previous_layer)
    _(layer.instance_variable_get(:@rate)).must_equal 0.1
    _(layer.instance_variable_get(:@mask)).must_equal 1.1111111111111112
  end

  it "initializes with a specified dropout rate" do
    _(layer.instance_variable_get(:@rate)).must_equal 0.2
    _(layer.instance_variable_get(:@mask)).must_equal 1.25
  end

  it "does not mask any activations when forwarding activations" do
    layer.assign_cache(cache)
    layer.forward(inputs, false)
    _(cache.activations(layer.index)).must_equal inputs
    _(cache.activations(layer.index).map(&:sum).sum).must_equal 60
  end

  it "masks some activations when forwarding activations for training" do
    layer.assign_cache(cache)

    sums = 100.times.map do
      layer.forward(inputs, true)
      cache.activations(layer.index).map(&:sum).sum
    end
    _(sums.min).must_be :>=, 32.5
    _(sums.max).must_be :<=, 75.0
    _(sums.uniq.size).must_be :>, 1
    _(cache.activations(layer.index).flatten.uniq.sort).must_equal [0.0, 1.25, 2.5]
  end
end
