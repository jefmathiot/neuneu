# frozen_string_literal: true

require "test_helper"

describe Neuneu::Normalizer::Enumerator do
  it "uses inner normalizers to convert inputs" do
    normalizers = [
      Minitest::Mock.new.expect(:convert, 3, [1]),
      Minitest::Mock.new.expect(:convert, 4, [2])
    ]
    _(Neuneu::Normalizer::Enumerator.new(normalizers).convert([1, 2])).must_equal [3, 4]
  end

  it "uses inner normalizers to revert outputs" do
    normalizers = [
      Minitest::Mock.new.expect(:revert, 3, [1]),
      Minitest::Mock.new.expect(:revert, 4, [2])
    ]
    _(Neuneu::Normalizer::Enumerator.new(normalizers).revert([1, 2])).must_equal [3, 4]
  end
end
