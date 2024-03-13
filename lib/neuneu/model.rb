# frozen_string_literal: true

module Neuneu
  class Model
    def initialize(backend: :ruby)
      @backend = Object.const_get("Neuneu::#{backend.capitalize}::Backend").new
    end

    def append(*args, **kwargs)
      @backend.append(*args, **kwargs)
      self
    end

    def fit(dataset, *args, **kwargs)
      @inputs_normalizer = dataset.inputs_normalizer
      @outputs_normalizer = dataset.outputs_normalizer
      @backend.fit(dataset, *args, **kwargs)
    end

    def predict(features)
      outputs = @backend.predict(features.map { |feature| @inputs_normalizer.convert(feature) })
      outputs.transpose.map { |prediction| @outputs_normalizer.revert(prediction) }
    end

    def history
      @backend.history
    end

    def plot(metrics: [], **opts)
      Plot.plot(history, metrics, **opts)
    end
  end
end
