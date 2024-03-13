# frozen_string_literal: true

module Neuneu
  module Ruby
    class History
      def initialize(metrics = {})
        @metrics = metrics.each_with_object({ training: [], validation: [] }) { |metric, h| h[metric] = [] }
      end

      def append(metric, value)
        @metrics[metric] << value
      end

      def get(metric)
        @metrics[metric]
      end
    end
  end
end
