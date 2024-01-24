# frozen_string_literal: true

require "test_helper"

describe Neuronface::Datasets::Memory do
  let(:klazz) { Neuronface::Datasets.get(:memory) }

  it "defaults to identity normalizers" do
    _(klazz.new([]).inputs_normalizer).must_be_instance_of Neuronface::Normalizer::Identity
    _(klazz.new([]).outputs_normalizer).must_be_instance_of Neuronface::Normalizer::Identity
    _(klazz.new([]).inputs_normalizer.convert(1)).must_equal 1
    _(klazz.new([]).outputs_normalizer.convert(1)).must_equal 1
  end

  it "provides the size of the examples" do
    _(klazz.new([1, 2, 3]).size).must_equal 3
  end

  it "allows access to raw examples" do
    _(klazz.new([1, 2, 3]).examples).must_equal [1, 2, 3]
  end

  it "shuffles examples" do
    examples = Array.new(10_000) { |i| i }
    _(klazz.new(examples).examples).must_equal(examples)
    _(klazz.new(examples).shuffle!.examples).wont_equal(examples)
  end

  describe "with a set of raw examples" do
    let(:data) do
      [
        [[-10, -20], [0, 20]],
        [[0, 0], [50, 110]],
        [[10, 20], [100, 200]]
      ]
    end

    let(:dataset) { klazz.new(data) }

    it "normalizes examples" do
      dataset.normalize!
      expected = [[[0.0, 0.0], [0.0, 0.0]], [[0.5, 0.5], [0.5, 0.5]], [[1.0, 1.0], [1.0, 1.0]]]
      _(dataset.raw_examples).must_equal expected
      _(dataset.inputs_normalizer).must_be_instance_of Neuronface::Normalizer::Enumerator
      _(dataset.outputs_normalizer).must_be_instance_of Neuronface::Normalizer::Enumerator
    end

    it "yields all examples at once" do
      _ { dataset.all }.must_raise(LocalJumpError)
      dataset.all { |examples| _(examples.size).must_equal data.size }
    end

    it "yields a batch of examples of a given size" do
      expected = []
      dataset.batch(2) { |examples| expected << examples.size }
      _(expected).must_equal [2, 1]
    end
  end
end
