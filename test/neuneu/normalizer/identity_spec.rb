# frozen_string_literal: true

require "test_helper"

describe Neuneu::Normalizer::Identity do
  it "uses the identity to convert" do
    _(Neuneu::Normalizer::Identity.new.convert(1.0)).must_equal 1.0
  end

  it "uses the identity to revert" do
    _(Neuneu::Normalizer::Identity.new.revert(1.0)).must_equal 1.0
  end
end
