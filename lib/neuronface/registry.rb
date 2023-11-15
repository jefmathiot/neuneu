# frozen_string_literal: true

module Neuronface
  module Registry
    def register_as(id, klazz)
      @functors ||= {}
      @functors[id] = klazz
    end

    def get(id)
      @functors[id]
    end
  end
end
