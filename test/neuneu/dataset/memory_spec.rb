# frozen_string_literal: true

require "test_helper"

describe Neuneu::Dataset::Memory do
  let(:klazz) { Neuneu::Dataset::Memory }
  let(:training_data) do
    [
      [
        [1.0, 2.0, 3.0],
        [7.0, 8.0, 9.0]
      ],
      [
        [10.0, 11.0, 12.0],
        [16.0, 17.0, 18.0]
      ]
    ]
  end
  let(:validation_data) do
    [
      [
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 6.0]
      ],
      [
        [7.0, 8.0, 9.0],
        [10.0, 11.0, 12.0]
      ]
    ]
  end

  it "defaults to identity normalizers" do
    _(klazz.new([]).inputs_normalizer).must_be_instance_of Neuneu::Normalizer::Identity
    _(klazz.new([]).outputs_normalizer).must_be_instance_of Neuneu::Normalizer::Identity
    _(klazz.new([]).inputs_normalizer.convert(1)).must_equal 1
    _(klazz.new([]).outputs_normalizer.convert(1)).must_equal 1
  end

  it "provides the features for training" do
    dataset = klazz.new(training_data)
    _(dataset.features.size).must_equal 2
    _(dataset.features.first.size).must_equal 3
    _(dataset.features(:validation)).must_be_nil
  end

  it "provides the features for validation" do
    dataset = klazz.new(training_data, validation_data)
    _(dataset.features(:validation).size).must_equal 2
    _(dataset.features(:validation).first.size).must_equal 3
  end

  it "normalizes both inputs and outputs for training and validation sets" do
    dataset = klazz.new(training_data, validation_data)
    dataset.normalize!
    _(dataset.features).must_equal [[0.0, 0.0, 0.0], [1.0, 1.0, 1.0]]
    _(dataset.features(:validation)).must_equal [[0.0, 0.0, 0.0], [0.5, 0.5, 0.5]]
    _(dataset.labels).must_equal [[0.0, 0.0, 0.0], [1.0, 1.0, 1.0]]
    _(dataset.labels(:validation)).must_equal [[-0.5, -0.5, -0.5], [0.0, 0.0, 0.0]]
  end

  it "transposes both training and validation sets" do
    dataset = klazz.new(training_data, validation_data, transpose: true)
    _(dataset.features).must_equal [[1.0, 2.0, 3.0], [10.0, 11.0, 12.0]]
    _(dataset.features(:validation)).must_equal [[1.0, 2.0, 3.0], [7.0, 8.0, 9.0]]
    _(dataset.labels).must_equal [[7.0, 8.0, 9.0], [16.0, 17.0, 18.0]]
    _(dataset.labels(:validation)).must_equal [[4.0, 5.0, 6.0], [10.0, 11.0, 12.0]]
  end

  it "shuffles examples from training data" do
    features = []
    labels = []
    klazz.new([training_data.first * 10, training_data.last * 10]).shuffle!.each_batch(1) do |feature, label|
      features << feature.first
      labels << label.first
    end
    _(features).wont_equal training_data.first * 10
    _(labels).wont_equal training_data.last * 10
  end
end
