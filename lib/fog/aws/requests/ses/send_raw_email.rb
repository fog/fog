module Fog
  module AWS
    class SES
      class Real

        require 'fog/aws/parsers/ses/send_raw_email'

        # Delete an existing verified email address
        #
        # ==== Parameters
        # * Destinations <~Array> - The destination for this email, composed of To:, From:, and CC: fields.
        # * RawMessage <~Hash> - The message to be sent.
        #   * Data <~String>
        # * Source <~String> - The sender's email address
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'DeleteVerfiedEmailAddressResponse'<~nil>
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def send_raw_email()
          # TODO: Make this work
          params = AWS.indexed_param('ReplyToAddresses.member', [*reply_to_addresses])

          request({
            'Action'           => 'SendRawEmail',
            :parser            => Fog::Parsers::AWS::SES::SendRawEmail.new
          }.merge(params))
        end

      end

      class Mock

        def send_raw_email()
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
