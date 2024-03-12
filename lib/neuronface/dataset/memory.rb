# frozen_string_literal: true

require "forwardable"

module Neuronface
  module Dataset
    class Memory
      extend Forwardable

      attr_accessor :inputs_normalizer, :outputs_normalizer

      def_delegator :@inputs_normalizer, :convert
      def_delegator :@outputs_normalizer, :revert
      def_delegator :@examples, :size

      def initialize(examples, transpose: false)
        store_examples(examples, transpose)
        @shuffle = false
        @inputs_normalizer = Normalizer::Identity.new
        @outputs_normalizer = Normalizer::Identity.new
      end

      def shuffle!
        @shuffle = true
        self
      end

      def normalize!
        @inputs_normalizer = build_normalizer(@features)
        @outputs_normalizer = build_normalizer(@labels)
        @features = @features.map { |example| @inputs_normalizer.convert(example) }
        @labels = @labels.map { |label| @outputs_normalizer.convert(label) }
        self
      end

      def batch(size)
        indices.each_slice(size) do |indices|
          yield @features.values_at(*indices), @labels.values_at(*indices)
        end
      end

      private

      def store_examples(examples, transpose)
        examples.send(transpose ? :transpose : :itself).tap do |ex|
          @features = ex.first
          @labels = ex.last
        end
      end

      def indices
        @indices ||= Array.new(@features.size) { |i| i }
        return @indices unless @shuffle

        @indices.shuffle
      end

      def build_normalizer(collection)
        normalizers = collection.transpose.map do |column|
          Normalizer::Scale.new(column)
        end
        Normalizer::Enumerator.new(normalizers)
      end
    end
  end
end
