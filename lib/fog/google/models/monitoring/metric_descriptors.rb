require 'fog/core/collection'
require 'fog/google/models/monitoring/metric_descriptor'

module Fog
  module Google
    class Monitoring
      class MetricDescriptors < Fog::Collection
        model Fog::Google::Monitoring::MetricDescriptor

        ##
        # Lists all Metric Descriptors.
        #
        # @param [Hash] options Optional query parameters.
        # @option options [String] count Maximum number of time series descriptors per page. Used for pagination.
        # @option options [String] page_token The pagination token, which is used to page through large result sets.
        # @option options [String] query The query used to search against existing metrics. Separate keywords with a space;
        #   the service joins all keywords with AND, meaning that all keywords must match for a metric to be returned.
        #   If this field is omitted, all metrics are returned. If an empty string is passed with this field,
        #   no metrics are returned.
        # @return [Array<Fog::Google::Monitoring::MetricDescriptor>] List of Metric Descriptors.
        def all(options = {})
          data = service.list_metric_descriptors(options).body['metrics'] || []
          load(data)
        end
      end
    end
  end
end
