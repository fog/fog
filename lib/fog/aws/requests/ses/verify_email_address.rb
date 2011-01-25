module Fog
  module AWS
    class SES
      class Real

        require 'fog/aws/parsers/ses/verify_email_address'

        # Verifies an email address. This action causes a confirmation email message to be sent to the specified address.
        #
        # ==== Parameters
        # * email_address<~String> - The email address to be verified
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'VerifyEmailAddressResult'<~nil>
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def verify_email_address(email_address)
          request({
            'Action'           => 'VerifyEmailAddress',
            'EmailAddress'     => email_address,
            :parser            => Fog::Parsers::AWS::SES::VerifyEmailAddress.new
          })
        end

      end

      class Mock

        def verify_email_address(email_address)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
