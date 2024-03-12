# frozen_string_literal: true

module Neuronface
  module Ruby
    module Vector
      def self.dot(vector1, vector2)
        vector1.map.with_index { |v, i| v * vector2[i] }.sum(0.0)
      end

      def self.add(vector, value)
        multival_operation(:+, vector, value)
      end

      def self.substract(vector, value)
        multival_operation(:-, vector, value)
      end

      def self.multiply(vector, value)
        multival_operation(:*, vector, value)
      end

      def self.divide(vector, value)
        multival_operation(:/, vector, value)
      end

      def self.mean(vector)
        vector.sum.to_f / vector.size
      end

      def self.square(vector)
        vector.map { |v| v**2 }
      end

      def self.multival_operation(operand, vector, value)
        if value.is_a?(Enumerable)
          vector.map.with_index { |v, i| v.send(operand, value[i]) }
        else
          vector.map { |item| item.send(operand, value) }
        end
      end
    end
  end
end
