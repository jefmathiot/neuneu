# frozen_string_literal: true

require "test_helper"

describe Neuneu::Ruby::Optimizer::RmsProp do
  let(:klazz) { Neuneu::Ruby::Optimizer::RmsProp }
  let(:layers) do
    [
      l0 = Neuneu::Ruby::Layer::Input.new(2, 0, nil),
      l1 = Neuneu::Ruby::Layer::Dense.new(2, 1, l0, transfer: :sigmoid),
      l2 = Neuneu::Ruby::Layer::Dropout.new(nil, 2, l1),
      Neuneu::Ruby::Layer::Dense.new(2, 3, l2, transfer: :sigmoid)
    ]
  end
  let(:cache) { Neuneu::Ruby::Cache::Training.new(layers) }

  before do
    cache.activations(0, [[1.0, 1.0], [1.0, 1.0]])
    cache.activations(1, [[1.0, 1.0], [1.0, 1.0]])
    cache.activations(2, [[1.0, 1.0], [1.0, 1.0]])
    cache.activations(3, [[1.0, 1.0], [1.0, 1.0]])
    cache.biases(1, [0.1, 0.2])
    cache.biases(3, [0.3, 0.4])
    cache.weights(1, [[0.5], [1.0]])
    cache.weights(3, [[2.0, 3.0], [4.0, 5.0]])
    cache.deltas(1, [0.25, 0.25])
    cache.deltas(3, [0.5, 0.5])
  end

  it "adjust parameters" do
    optimizer = klazz.new
    optimizer.adjust_parameters(layers, cache)
    _(cache.weights(1)).must_equal [[0.49683772633982654], [0.9968377263398266]]
    _(cache.weights(3)).must_equal [[1.9968377243398303, 2.9968377243398305], [3.9968377243398305, 4.99683772433983]]
    optimizer.adjust_parameters(layers, cache)
    _(cache.weights(1)).must_equal [[0.49454357110638214], [0.9945435711063823]]
    _(cache.weights(3)).must_equal [[1.9945435680537558, 2.994543568053756], [3.994543568053756, 4.994543568053755]]
  end

  it "adjust parameters with specified learning rate and rho" do
    optimizer = klazz.new(learning_rate: 0.005, rho: 0.8)
    optimizer.adjust_parameters(layers, cache)
    _(cache.weights(1)).must_equal [[0.4888196701124921], [0.988819670112492]]
    _(cache.weights(3)).must_equal [[1.9888196651124987, 2.9888196651124987], [3.9888196651124987, 4.988819665112499]]
    optimizer.adjust_parameters(layers, cache)
    _(cache.weights(1)).must_equal [[0.4804863423347106], [0.9804863423347105]]
    _(cache.weights(3)).must_equal [[1.9804863345569423, 2.980486334556942], [3.980486334556942, 4.980486334556942]]
  end
end
