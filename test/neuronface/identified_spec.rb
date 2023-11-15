# frozen_string_literal: true

require "test_helper"
require "neuronface/identified"

class TestDoubleIdentified
  include Neuronface::Identified
end

describe Neuronface::Identified do
  it "builds identity for an object in the network" do
    dummy = TestDoubleIdentified.new
    dummy.identify(1, "base_name")
    _(dummy.index).must_equal 1
    _(dummy.name).must_equal "base_name_1"
  end
end
