module Fog
  module AWS
    class CloudWatch
      class Real

        require 'fog/aws/parsers/cloud_watch/put_metric_data'

        # Publishes one or more data points to CloudWatch. A new metric is created if necessary
        # ==== Options
        # * Namespace<~String>: the namespace of the metric data
        # * MetricData<~Array>: the datapoints to publish of the metric
        #     * MetricName<~String>: the name of the metric
        #     * Timestamp<~String>: the timestamp for the data point. If omitted defaults to the time at which the data is received by CloudWatch 
        #     * Unit<~String>: the unit
        #     * Value<~Double> the value for the metric
        #     * StatisticValues<~Hash>:
        #         * Maximum<~Double>: the maximum value of the sample set
        #         * Sum<~Double>: the sum of the values of the sample set
        #         * SampleCount<~Double>: the number of samples used for the statistic set
        #         * Minimum<~Double>: the minimum value of the sample set
        #     * Dimensions<~Array>: the dimensions for the metric. From 0 to 10 may be included
        #          * Name<~String>
        #         * Value<~String>
        # ==== Returns
        # * response<~Excon::Response>:
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonCloudWatch/latest/APIReference/API_PutMetricData.html
        #
        def put_metric_data(namespace, metric_data)
          statistics = options.delete 'Statistics'
          options.merge!(AWS.indexed_param('Statistics.member.%d', [*statistics])
          
          if dimensions = options.delete 'Dimensions'
            options.merge!(AWS.indexed_param('Dimensions.member.%d.Name', dimensions.collect {|dimension| dimension['Name']}))
            options.merge!(AWS.indexed_param('Dimensions.member.%d.Value', dimensions.collect {|dimension| dimension['Value']}))
          end

          request({
              'Action'    => 'GetMetricStatistics',
              :parser     => Fog::Parsers::AWS::CloudWatch::GetMetricStatistics.new
            }.merge(options))
        end

      end
    end
  end
end
