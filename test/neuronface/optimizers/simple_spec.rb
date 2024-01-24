# frozen_string_literal: true

require "test_helper"

describe Neuronface::Optimizers::Simple do
  let(:dataset) do
    Class.new do
      def all
        yield [
          [[0], [1]],
          [[2], [3]]
        ]
      end
    end.new
  end

  let(:neuron_klazz) do
    Class.new do
      attr_reader :activation

      def initialize(activation)
        @activation = activation
      end
    end
  end

  %i[model loss].each do |object|
    let(object) { Minitest::Mock.new }
  end

  let(:layers) do
    2.times.map do
      layer = Minitest::Mock.new
      layer
    end
  end

  def expect_feed(input)
    model.expect :feed, nil, [input]
  end

  def expect_total_loss(output, output_loss)
    model.expect :layers, layers
    layers.last.expect(:neurons, 2.times.map { |i| neuron_klazz.new((i + 1) / 2.0) })
    loss.expect :total_loss, output_loss, [[0.5, 1], output]
  end

  def expect_forward(input, output, output_loss)
    expect_feed(input)
    model.expect :loss, loss
    expect_total_loss(output, output_loss)
  end

  def expect_backprop(outputs, learning_rate)
    model.expect :layers, layers
    layers.reverse.each { |layer| layer.expect :compute_deltas, nil, [outputs] }
    model.expect :layers, layers
    layers.last.expect :adjust_parameters, nil, [learning_rate]
  end

  it "runs on all examples for a single epoch" do
    expect_forward([0], [1], 1.0)
    expect_backprop([1], 0.5)
    expect_forward([2], [3], 3.0)
    expect_backprop([3], 0.5)

    optimizer = Neuronface::Optimizers::Simple.new(model)
    history = optimizer.run(dataset)
    model.verify
    _(history[:loss]).must_equal [2.0]
  end

  it "runs on all examples for two epochs" do
    2.times do |i|
      expect_forward([0], [1], (i + 1) * 2.0)
      expect_backprop([1], 0.01)
      expect_forward([2], [3], (i + 1) * 2.0)
      expect_backprop([3], 0.01)
    end

    optimizer = Neuronface::Optimizers::Simple.new(model, epochs: 2, learning_rate: 0.01)
    history = optimizer.run(dataset)
    model.verify
    _(history[:loss]).must_equal [2.0, 4.0]
  end
end
