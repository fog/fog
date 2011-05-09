module Fog
  module AWS
    class Compute
      class Real

        require 'fog/compute/parsers/aws/get_password_data'

        # Retrieves the encrypted administrator password for an instance running Windows.
        #
        # ==== Parameters
        # * instance_id<~String> - A Windows instance ID
        #
        # ==== Returns
        # # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'instanceId'<~String> - Id of instance
        #     * 'passwordData'<~String> - The encrypted, base64-encoded password of the instance.
        #     * 'requestId'<~String> - Id of request
        #     * 'timestamp'<~Time> - Timestamp of last update to output
        #
        # See http://docs.amazonwebservices.com/AWSEC2/2010-08-31/APIReference/index.html?ApiReference-query-GetPasswordData.html
        def get_password_data(instance_id)
          request(
            'Action'      => 'GetPasswordData',
            'InstanceId'  => instance_id,
            :idempotent   => true,
            :parser       => Fog::Parsers::AWS::Compute::GetPasswordData.new
          )
        end

      end

      class Mock

        def get_password_data(instance_id)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
