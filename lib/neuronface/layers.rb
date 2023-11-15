# frozen_string_literal: true

require "neuronface/registry"

module Neuronface
  module Layers
    extend Registry
  end
end

require "neuronface/layers/layer"
require "neuronface/layers/input"
require "neuronface/layers/dense"
