# frozen_string_literal: true

require "unicode_plot"

module Neuneu
  module Plot
    def self.plot(history, metrics = %i[], **opts)
      range = 1..history.get(:training).size
      UnicodePlot.lineplot(range, history.get(:training), name: :training, **opts).tap do |plot|
        metrics.each { |metric| plot.lineplot!(range, history(metric), name: metric, **opts) }
      end
    end
  end
end
