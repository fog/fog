require 'fog/core/model'

module Fog
  module Google
    class Monitoring
      ##
      # A time series is a collection of data points that represents the value of a metric of a project over time.
      #
      # @see https://developers.google.com/cloud-monitoring/v2beta1/timeseries
      class Timeseries < Fog::Model
        identity :time_series_desc, :aliases => 'timeseriesDesc'

        attribute :points
      end
    end
  end
end
