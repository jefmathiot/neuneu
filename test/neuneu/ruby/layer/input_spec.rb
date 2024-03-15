# frozen_string_literal: true

require "test_helper"

describe Neuneu::Ruby::Layer::Input do
  let(:layer) { Neuneu::Ruby::Layer::Input.new(2, 0, nil) }
  let(:cache) { Neuneu::Ruby::Cache::FeedForward.new([layer]) }

  before do
    layer.assign_cache(cache)
  end

  it "initializes properly" do
    _(layer.size).must_equal 2
    _(layer.index).must_equal 0
  end

  it "forwards the transposed inputs to the cache" do
    layer.forward([[1, 2], [3, 4]])
    _(cache.activations(0)).must_equal [[1, 3], [2, 4]]
  end

  it "isn't weighted" do
    _(layer.weighted?).must_equal false
  end
end
