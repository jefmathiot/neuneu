# frozen_string_literal: true

require "test_helper"

describe Neuronface::Ruby::KernelInitializer::HeNormal do
  let(:klazz) { Neuronface::Ruby::KernelInitializer::HeNormal }

  it "provides values" do
    initializer = klazz.new(fan_in: 3, fan_out: nil)
    100.times do
      value = initializer.next
      _(value).wont_be :<, -7
      _(value).wont_be :>, 7
    end
  end
end
