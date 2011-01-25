module Fog
  module AWS
    class SES
      class Real

        require 'fog/aws/parsers/ses/list_verified_email_addresses'

        # Returns a list containing all of the email addresses that have been verified
        #
        # ==== Parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ListVerifiedEmailAddressesResult'<~Hash>
        #       * 'VerifiedEmailAddresses' <~Array>
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def list_verified_email_addresses
          request({
            'Action' => 'ListVerifiedEmailAddresses',
            :parser  => Fog::Parsers::AWS::SES::ListVerifiedEmailAddresses.new
          })
        end

      end

      class Mock

        def list_verified_email_addresses
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
