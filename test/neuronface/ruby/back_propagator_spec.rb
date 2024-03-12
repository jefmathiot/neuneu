# frozen_string_literal: true

require "test_helper"

describe Neuronface::Ruby::BackPropagator do
  let(:klazz) { Neuronface::Ruby::BackPropagator }
  let(:backend) do
    Neuronface::Ruby::Backend.new.tap do |backend|
      backend.append :input, 1
      backend.append :dense, 1, transfer: :leaky_relu
      backend.send(:build_cache)
      backend.send(:before_training!)
    end
  end
  let(:data) do
    [
      [[-40.0], [-40.0]],
      [[-10.0], [14.0]],
      [[0.0], [32.0]],
      [[8.0], [46.4]],
      [[15.0], [59.0]],
      [[22.0], [71.6]],
      [[38.0], [100.4]]
    ]
  end
  let(:dataset) { Neuronface::Dataset::Memory.new(data, transpose: true).normalize! }

  it "runs on the dataset for 100 epochs" do
    klazz.new(backend, :sgd).run(dataset, 100, 2, :mean_squared_error)
    _(backend.history.get(:training).size).must_equal 100
    _(backend.history.get(:training).last).must_be :<, backend.history.get(:training).first
  end
end
