require 'fog/core/collection'
require 'fog/aws/models/cloud_watch/metric'

module Fog
  module AWS
    class CloudWatch

      class Metrics < Fog::Collection
        model Fog::AWS::CloudWatch::Metric
        
        def all
          data = connection.list_metrics.body['ListMetricsResult']['Metrics']
          load(data) # data is an array of attribute hashes
        end
        
        def get(namespace, metric_name, dimensions=nil)
          list_opts = {'Namespace' => namespace, 'MetricName' => metric_name}
          if dimensions
            dimensions_array = dimensions.collect do |name, value|
              {'Name' => name, 'Value' => value}
            end
            puts dimensions_array.inspect
            # list_opts.merge!('Dimensions' => dimensions_array) 
          end
          data = connection.list_metrics(list_opts).body['ListMetricsResult']['Metrics'].first
          new(data)
        end
        
      end
    end
  end
end
