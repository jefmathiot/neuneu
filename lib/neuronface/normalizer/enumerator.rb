# frozen_string_literal: true

module Neuronface
  module Normalizer
    class Enumerator
      def initialize(normalizers)
        @normalizers = normalizers
      end

      def convert(input)
        input.map.with_index { |value, index| @normalizers[index].convert(value) }
      end

      def revert(output)
        output.map.with_index { |value, index| @normalizers[index].revert(value) }
      end
    end
  end
end
