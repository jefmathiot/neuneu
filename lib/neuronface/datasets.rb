# frozen_string_literal: true

require "neuronface/registry"

module Neuronface
  module Datasets
    extend Registry
  end
end

require "neuronface/datasets/memory"
