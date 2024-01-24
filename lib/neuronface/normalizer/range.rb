# frozen_string_literal: true

module Neuronface
  module Normalizer
    class Range
      def initialize(values, range = (0..1))
        @xmin = values.min
        @xrange = (values.max - @xmin).to_f
        @xrange = Float::MIN if @xrange.zero?
        @ymin = range.min
        @yrange = (range.max - @ymin).to_f
      end

      def convert(input)
        @ymin + ((input - @xmin) * @yrange / @xrange)
      end

      def revert(output)
        @xmin + ((output - @ymin) * @xrange / @yrange)
      end
    end
  end
end
