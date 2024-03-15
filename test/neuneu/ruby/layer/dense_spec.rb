# frozen_string_literal: true

require "test_helper"

describe Neuneu::Ruby::Layer::Dense do
  let(:previous_layer) { Neuneu::Ruby::Layer::Input.new(2, 0, nil) }
  let(:klazz) { Neuneu::Ruby::Layer::Dense }
  let(:cache_klazz) { Neuneu::Ruby::Cache::Training }

  it "raises unless transfer function provided" do
    _ { klazz.new(2, 1, previous_layer) }.must_raise
  end

  it "initializes the transfer function and default initializer" do
    layer = klazz.new(2, 1, previous_layer, transfer: :sigmoid)
    _(layer.instance_variable_get(:@transfer_function)).wont_be_nil
    _(layer.instance_variable_get(:@kernel_initializer)).wont_be_nil
  end

  it "initializes the transfer function with a custom initializer" do
    layer = klazz.new(2, 1, previous_layer, transfer: :sigmoid, kernel_initializer: :he_normal)
    _(layer.instance_variable_get(:@transfer_function)).wont_be_nil
    _(layer.instance_variable_get(:@kernel_initializer)).must_be_instance_of Neuneu::Ruby::KernelInitializer::HeNormal
    _(layer.instance_variable_get(:@kernel_initializer).instance_variable_get(:@mean)).must_equal 0.0
    _(layer.instance_variable_get(:@kernel_initializer).instance_variable_get(:@std_deviation)).must_equal 1.0
  end

  describe "with a 3 neurons layer and a cache" do
    let(:layer) { klazz.new(3, 1, previous_layer, transfer: :leaky_relu) }
    let(:cache) { cache_klazz.new([previous_layer, layer]) }

    before do
      layer.assign_cache(cache)
    end

    it "sets up weights and biases before training" do
      layer.before_training!
      _(cache.weights(layer.index).size).must_equal 3
      _(cache.biases(layer.index).size).must_equal 3
      _(cache.weights(layer.index).first.size).must_equal 2
    end

    it "is weighted" do
      _(layer.weighted?).must_equal true
    end

    describe "with a fixed set of weights and biases" do
      before do
        cache.weights(layer.index, [[0.5, 1.0], [1.5, 2.0], [2.5, 3.0]])
        cache.biases(layer.index, [0.5, 1.0, 1.5])
      end

      it "forwards activations to the cache" do
        layer.forward([[1.0, 2.0], [3.0, 4.0]], false)
        _(cache.activations(layer.index)).must_equal [[4.0, 5.5], [8.5, 12.0], [13.0, 18.5]]
        _(cache.derivatives(layer.index)).must_equal [0.0, 0.0, 0.0]
      end

      it "forwards activations and derivatives to the cache" do
        layer.forward([[1.0, 2.0], [3.0, 4.0]], true)
        _(cache.activations(layer.index)).must_equal [[4.0, 5.5], [8.5, 12.0], [13.0, 18.5]]
        _(cache.derivatives(layer.index)).must_equal [2.0, 2.0, 2.0]
      end
    end
  end
end
