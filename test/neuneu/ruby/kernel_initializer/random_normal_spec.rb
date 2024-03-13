# frozen_string_literal: true

require "test_helper"

describe Neuneu::Ruby::KernelInitializer::RandomNormal do
  let(:klazz) { Neuneu::Ruby::KernelInitializer::RandomNormal }

  it "provides values" do
    initializer = klazz.new(mean: 0, std_deviation: 0.1)
    100.times do
      value = initializer.next
      _(value).wont_be :<, -0.86
      _(value).wont_be :>, 0.86
    end
  end
end
