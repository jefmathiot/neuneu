# frozen_string_literal: true

require "forwardable"

module Neuneu
  module Dataset
    class Memory
      extend Forwardable

      attr_accessor :inputs_normalizer, :outputs_normalizer

      def_delegator :@inputs_normalizer, :convert
      def_delegator :@outputs_normalizer, :revert

      def initialize(training, validation = nil, transpose: false)
        initialize_store
        store_examples(:training, training, transpose)
        store_examples(:validation, validation, transpose) if validation
        @shuffle = false
        @inputs_normalizer = Normalizer::Identity.new
        @outputs_normalizer = Normalizer::Identity.new
      end

      def shuffle!
        @shuffle = true
        self
      end

      def normalize!
        @inputs_normalizer = build_normalizer(features)
        @outputs_normalizer = build_normalizer(labels)
        %i[training validation].each do |purpose|
          store(purpose, :features, features(purpose)&.map { |example| @inputs_normalizer.convert(example) })
          store(purpose, :labels, labels(purpose)&.map { |example| @outputs_normalizer.convert(example) })
        end
        self
      end

      def each_batch(size)
        indices.each_slice(size) do |indices|
          yield features.values_at(*indices), labels.values_at(*indices)
        end
      end

      def features(purpose = :training)
        @store.dig(purpose, :features)
      end

      def labels(purpose = :training)
        @store.dig(purpose, :labels)
      end

      private

      def initialize_store
        @store = { training: {}, validation: {} }
      end

      def store_examples(purpose, examples, transpose)
        examples.send(transpose ? :transpose : :itself).tap do |ex|
          store(purpose, :features, ex.first)
          store(purpose, :labels, ex.last)
        end
      end

      def store(purpose, name, value)
        @store[purpose][name] = value
      end

      def indices
        @indices ||= Array.new(features.size) { |i| i }
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
