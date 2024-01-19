# frozen_string_literal: true

require "test_helper"

describe Neuronface::Vector do
  it "performs a dot product on a pair of vectors" do
    _(Neuronface::Vector.dot([1.0, 2.0, 3.0], [4.0, 5.0, 6.0])).must_equal 32
  end

  it "adds a value to vector components" do
    _(Neuronface::Vector.add([1.0, 2.0], 2)).must_equal [3, 4]
  end

  it "subsctracts a value from vector components" do
    _(Neuronface::Vector.substract([1.0, 2.0], 2)).must_equal [-1, 0]
  end

  it "multiplies vector components with a value" do
    _(Neuronface::Vector.multiply([1.0, 2.0], 2)).must_equal [2, 4]
  end

  it "divides vector components by a value" do
    _(Neuronface::Vector.divide([1.0, 2.0], 2)).must_equal [0.5, 1]
  end
end
