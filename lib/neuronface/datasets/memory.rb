# frozen_string_literal: true

require "forwardable"

module Neuronface
  module Datasets
    class Memory
      extend Forwardable

      Datasets.register_as(:memory, self)

      attr_accessor :inputs_normalizer, :outputs_normalizer

      def_delegator :@inputs_normalizer, :convert
      def_delegator :@outputs_normalizer, :revert
      def_delegator :@examples, :size

      def initialize(examples)
        @examples = examples
        @shuffle_method = :itself
        @inputs_normalizer = Normalizer::Identity.new
        @outputs_normalizer = Normalizer::Identity.new
      end

      def shuffle!
        @shuffle_method = :shuffle
        self
      end

      def normalize!
        @examples.transpose.tap do |transposed|
          @inputs_normalizer = build_normalizer(transposed.first)
          @outputs_normalizer = build_normalizer(transposed.last)
        end
        @examples = @examples.map do |example|
          [@inputs_normalizer.convert(example.first), @outputs_normalizer.convert(example.last)]
        end
        self
      end

      def all
        yield examples
      end

      def batch(size, &block)
        examples.each_slice(size, &block)
      end

      def raw_examples
        @examples
      end

      def examples
        @examples.send(@shuffle_method)
      end

      private

      def normalize_inputs!
        @inputs_normalizer = normalize_collection!(:inputs)
      end

      def normalize_outputs!
        @outputs_normalizer = normalize_collection!(:outputs)
      end

      def build_normalizer(collection)
        normalizers = collection.transpose.map do |column|
          Normalizer::Range.new(column)
        end
        Normalizer::Enumerator.new(normalizers)
      end
    end
  end
end
