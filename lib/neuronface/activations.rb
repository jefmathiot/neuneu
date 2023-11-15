# frozen_string_literal: true

require "neuronface/registry"

module Neuronface
  module Activations
    extend Registry
  end
end

require "neuronface/activation/relu"
require "neuronface/activation/sigmoid"
