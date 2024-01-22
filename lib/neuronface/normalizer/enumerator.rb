# frozen_string_literal: true

module Neuronface
  module Normalizer
    class Enumerator
      def initialize(normalizers)
        @normalizers = normalizers
      end

      def convert(input)
        input.each_with_index.map { |value, index| @normalizers[index].convert(value) }
      end

      def revert(output)
        output.each_with_index.map { |value, index| @normalizers[index].revert(value) }
      end
    end
  end
end
