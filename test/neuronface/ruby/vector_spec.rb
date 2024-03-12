# frozen_string_literal: true

require "test_helper"

describe Neuronface::Ruby::Vector do
  it "performs a dot product on a pair of vectors" do
    _(Neuronface::Ruby::Vector.dot([1.0, 2.0, 3.0], [4.0, 5.0, 6.0])).must_equal 32
  end

  it "adds a value to vector components" do
    _(Neuronface::Ruby::Vector.add([1.0, 2.0], 2)).must_equal [3, 4]
  end

  it "adds two vectors" do
    _(Neuronface::Ruby::Vector.add([1.0, 2.0], [1.0, 2.0])).must_equal [2, 4]
  end

  it "substracts a value from vector components" do
    _(Neuronface::Ruby::Vector.substract([1.0, 2.0], 2)).must_equal [-1, 0]
  end

  it "substracts two vectors" do
    _(Neuronface::Ruby::Vector.substract([1.0, 2.0], [1.0, 2.0])).must_equal [0, 0]
  end

  it "multiplies vector components with a value" do
    _(Neuronface::Ruby::Vector.multiply([1.0, 2.0], 2)).must_equal [2, 4]
  end

  it "multiplies two vectors" do
    _(Neuronface::Ruby::Vector.multiply([1.0, 2.0], [2.0, 3.0])).must_equal [2, 6]
  end

  it "divides vector components by a value" do
    _(Neuronface::Ruby::Vector.divide([1.0, 2.0], 2)).must_equal [0.5, 1]
  end

  it "divides two vectors" do
    _(Neuronface::Ruby::Vector.divide([2.0, 6.0], [4.0, 2.0])).must_equal [0.5, 3.0]
  end

  it "provides the average value of a vector" do
    _(Neuronface::Ruby::Vector.mean([1.0, 2.0])).must_equal 1.5
  end

  it "squares a vector" do
    _(Neuronface::Ruby::Vector.square([1.0, 2.0])).must_equal [1.0, 4.0]
  end
end
