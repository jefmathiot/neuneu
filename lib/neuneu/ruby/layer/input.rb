# frozen_string_literal: true

module Neuneu
  module Ruby
    module Layer
      class Input < Base
        def initialize(size, index, _)
          super(size, index)
        end

        def forward(batch)
          @cache.activations(index, batch.transpose)
        end
      end
    end
  end
end
