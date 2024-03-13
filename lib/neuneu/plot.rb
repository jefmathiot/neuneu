# frozen_string_literal: true

require "unicode_plot"

module Neuneu
  module Plot
    def self.plot(history, metrics = %i[], **kwargs)
      range = 1..history.get(:training).size
      UnicodePlot.lineplot(range, history.get(:training), name: :training, **kwargs).tap do |plot|
        UnicodePlot.lineplot!(plot, range, history.get(:validation), name: :validation) if history.get(:validation).any?
        metrics.each { |metric| UnicodePlot.lineplot!(plot, range, history(metric), name: metric) }
      end
    end
  end
end
