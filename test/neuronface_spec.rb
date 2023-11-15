# frozen_string_literal: true

require "test_helper"

describe Neuronface do
  it "has a version number" do
    _(Neuronface::VERSION).wont_be_nil
  end
end
