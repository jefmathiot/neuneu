# frozen_string_literal: true

require "test_helper"

describe Neuneu do
  it "has a version number" do
    _(Neuneu::VERSION).wont_be_nil
  end
end
