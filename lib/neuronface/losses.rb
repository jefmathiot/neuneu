# frozen_string_literal: true

require "neuronface/registry"

module Neuronface
  module Losses
    extend Registry
  end
end

require "neuronface/loss/squared_error"
