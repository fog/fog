module Fog
  module AWS
    class CloudWatch
      class Real     

        require 'fog/aws/parsers/cloud_watch/describe_alarms'

        # Retrieves alarms with the specified names
        # ==== Options
        # * ActionPrefix<~String>: The action name prefix
        # * AlarmNamePrefix<~String>: The alarm name prefix. 
        #         AlarmNames cannot be specified if this parameter is specified
        # * AlarmNames<~Array>: A list of alarm names to retrieve information for. 
        # * MaxRecords<~Integer>: The maximum number of alarm descriptions to retrieve
        # * NextToken<~String>: The token returned by a previous call to indicate that there is more data available
        # * NextToken<~String> The token returned by a previous call to indicate that there is more data available
        # * StateValue<~String>: The state value to be used in matching alarms
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonCloudWatch/latest/APIReference/API_DescribeAlarms.html
        #

        def describe_alarms(options={})
          if alarm_names = options.delete('AlarmNames')
            options.merge!(AWS.indexed_param('AlarmNames.member.%d', [*alarm_names]))
          end
          request({
              'Action'    => 'DescribeAlarms',
              :parser     => Fog::Parsers::AWS::CloudWatch::DescribeAlarms.new
            }.merge(options))
        end
      end     
    end
  end
end
