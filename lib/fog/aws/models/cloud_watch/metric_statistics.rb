require 'fog/core/collection'
require 'fog/aws/models/cloud_watch/metric_statistic'

module Fog
  module AWS
    class CloudWatch

      class MetricStatistics < Fog::Collection
        model Fog::AWS::CloudWatch::MetricStatistic
        
        def all(filters)
          data = connection.get_metric_statistics(filters).body['GetMetricStatisticsResult']['Datapoints']
          load(data) # data is an array of attribute hashes
        end
        
      end
    end
  end
end
