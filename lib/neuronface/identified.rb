# frozen_string_literal: true

module Neuronface
  module Identified
    attr_reader :index, :name

    def identify(index, base_name)
      @index = index
      @name = "#{base_name}_#{index}"
    end
  end
end
