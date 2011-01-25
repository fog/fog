module Fog
  module AWS
    class SES
      class Real

        require 'fog/aws/parsers/ses/delete_verified_email'

        # Delete an existing verified email address
        #
        # ==== Parameters
        # * email_address<~String> - Email Address to be removed
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'DeleteVerfiedEmailAddressResponse'<~nil>
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def delete_verified_email_address(email_address)
          request({
            'Action'           => 'DeleteVerifiedEmailAddress',
            'EmailAddress'     => email_address,
            :parser            => Fog::Parsers::AWS::SES::DeleteVerifiedEmailAddress.new
          })
        end

      end

      class Mock

        def delete_verified_email_address(email_address)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
