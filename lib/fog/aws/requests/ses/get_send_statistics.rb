module Fog
  module AWS
    class SES
      class Real

        require 'fog/aws/parsers/ses/get_send_statistics'

        # Returns the user's current activity limits.
        #
        # ==== Parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'GetSendStatisticsResult'<~Hash>
        #       * 'SendDataPoints' <~Array>
        #         * 'Bounces' <~String>
        #         * 'Complaints' <~String>
        #         * 'DeliveryAttempts' <~String>
        #         * 'Rejects' <~String>
        #         * 'Timestamp' <~String>
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def get_send_statistics
          request({
            'Action' => 'GetSendStatistics',
            :parser  => Fog::Parsers::AWS::SES::GetSendStatistics.new
          })
        end

      end

      class Mock

        def get_send_statistics
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
