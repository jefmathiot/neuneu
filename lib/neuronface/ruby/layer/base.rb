# frozen_string_literal: true

module Neuronface
  module Ruby
    module Layer
      class Base
        attr_reader :size, :index, :activations

        def initialize(size, index)
          @size = size
          @index = index
        end

        def assign_cache(cache)
          @cache = cache
        end

        def before_training!; end

        def adjust_parameters(_deltas, _activations); end

        def weighted?
          false
        end
      end
    end
  end
end
