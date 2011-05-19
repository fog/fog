require 'fog/core/collection'
require 'fog/aws/models/cloud_watch/metric_statistic'

module Fog
  module AWS
    class CloudWatch
      class MetricStatistics < Fog::Collection
        model Fog::AWS::CloudWatch::MetricStatistic
        
        def all(filters)
          metricName = filters['MetricName']
          namespace = filters['Namespace']
          dimensions = filters['Dimensions']
          data = connection.get_metric_statistics(filters).body['GetMetricStatisticsResult']['Datapoints']
          data.collect! { |datum| datum.merge('MetricName' => metricName, 'Namespace' => namespace, 'Dimensions' => dimensions) }
          load(data) # data is an array of attribute hashes
        end
        
      end
    end
  end
end
