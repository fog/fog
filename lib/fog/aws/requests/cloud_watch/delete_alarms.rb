module Fog
  module AWS
    class CloudWatch
      class Real
      
        require 'fog/aws/parsers/cloud_watch/delete_alarms'
        
        # Delete a list of alarms
        # ==== Options
        # * AlarmNames<~Array>: An array of alarms to be deleted
        # 
        # ==== Returns
        # * response<~Excon::Response>:
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonCloudWatch/latest/APIReference/index.html?API_DeleteAlarms.html
        #
        
        def delete_alarms(alarms)
          options = {}
          options.merge!(AWS.indexed_param('AlarmNames.member.%d', [*alarms]))
          request({
              'Action'    => 'DeleteAlarms',
              :parser     => Fog::Parsers::AWS::CloudWatch::DeleteAlarms.new
            }.merge(options))
        end
      end       
    end
  end
end



