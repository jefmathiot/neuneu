# frozen_string_literal: true

require "test_helper"

describe Neuronface::Normalizer::Scale do
  describe "with the default output Scale" do
    it "converts value to the target Scale" do
      normalizer = Neuronface::Normalizer::Scale.new([-100, 0, 100])
      _(normalizer.convert(-100)).must_equal 0
      _(normalizer.convert(0)).must_equal 0.5
      _(normalizer.convert(100)).must_equal 1
    end

    it "reverts value to the input Scale" do
      normalizer = Neuronface::Normalizer::Scale.new([-100, 0, 100])
      _(normalizer.revert(0)).must_equal(-100)
      _(normalizer.revert(0.5)).must_equal 0
      _(normalizer.revert(1)).must_equal 100
    end
  end

  describe "with a provided output Scale" do
    it "converts value to the target Scale" do
      normalizer = Neuronface::Normalizer::Scale.new([-100, 0, 100], (-1..1))
      _(normalizer.convert(-100)).must_equal(-1)
      _(normalizer.convert(0)).must_equal 0
      _(normalizer.convert(100)).must_equal 1
    end

    it "reverts value to the input Scale" do
      normalizer = Neuronface::Normalizer::Scale.new([-100, 0, 100], (-1..1))
      _(normalizer.revert(-1)).must_equal(-100)
      _(normalizer.revert(0)).must_equal 0
      _(normalizer.revert(1)).must_equal 100
    end

    it "avoids division by zero when inputs are identical" do
      normalizer = Neuronface::Normalizer::Scale.new([1, 1])
      _(normalizer.revert(-1)).must_equal 1.0
      _(normalizer.revert(0)).must_equal 1.0
      _(normalizer.revert(1)).must_equal 1.0
    end
  end
end
