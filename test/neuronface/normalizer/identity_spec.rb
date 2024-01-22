# frozen_string_literal: true

require "test_helper"

describe Neuronface::Normalizer::Identity do
  it "uses the identity to convert" do
    _(Neuronface::Normalizer::Identity.new.convert(1.0)).must_equal 1.0
  end

  it "uses the identity to revert" do
    _(Neuronface::Normalizer::Identity.new.revert(1.0)).must_equal 1.0
  end
end
