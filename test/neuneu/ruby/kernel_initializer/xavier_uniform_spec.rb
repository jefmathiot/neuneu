# frozen_string_literal: true

require "test_helper"

describe Neuneu::Ruby::KernelInitializer::XavierUniform do
  let(:klazz) { Neuneu::Ruby::KernelInitializer::XavierUniform }

  it "provides values" do
    initializer = klazz.new(fan_in: 3, fan_out: 3)
    100.times do
      value = initializer.next
      _(value).wont_be :<, -(Math.sqrt(6.0) / Math.sqrt(6))
      _(value).wont_be :>, (Math.sqrt(6.0) / Math.sqrt(6))
    end
  end
end
