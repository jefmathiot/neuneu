# frozen_string_literal: true

module Neuronface
  module Normalizer
    class Identity
      def convert(value)
        value
      end

      def revert(value)
        value
      end
    end
  end
end
