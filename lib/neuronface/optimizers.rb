# frozen_string_literal: true

require "neuronface/registry"

module Neuronface
  module Optimizers
    extend Registry
  end
end

require "neuronface/optimizers/simple"
