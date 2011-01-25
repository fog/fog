module Fog
  module AWS
    class SES
      class Real

        require 'fog/aws/parsers/ses/send_email'

        # Delete an existing verified email address
        #
        # ==== Parameters
        # * Destination <~Hash> - The destination for this email, composed of To:, From:, and CC: fields.
        #   * BccAddresses <~Array> - The BCC: field(s) of the message.
        #   * CcAddresses <~Array> - The CC: field(s) of the message.
        #   * ToAddresses <~Array> - The To: field(s) of the message.
        # * Message <~Hash> - The message to be sent.
        #   * Body <~Hash>
        #     * Html <~Hash>
        #       * Charset <~String>
        #       * Data <~String>
        #     * Text <~Hash>
        #       * Charset <~String>
        #       * Data <~String>
        #   * Subject <~Hash>
        #     * Charset <~String>
        #     * Data <~String>
        # * ReplyToAddresses <~Array> - The reply-to email address(es) for the message. If the recipient replies to the message, each reply-to address will receive the reply.
        # * ReturnPath <~String> - The email address to which bounce notifications are to be forwarded. If the message cannot be delivered to the recipient, then an error message will be returned from the recipient's ISP; this message will then be forwarded to the email address specified by the ReturnPath parameter.
        # * Source <~String> - The sender's email address
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'DeleteVerfiedEmailAddressResponse'<~nil>
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def send_email()
          params = AWS.indexed_param('ReplyToAddresses.member', [*reply_to_addresses])

          request({
            'Action'           => 'DeleteVerifiedEmailAddress',
            'EmailAddress'     => email_address,
            :parser            => Fog::Parsers::AWS::SES::DeleteVerifiedEmailAddress.new
          }.merge(params))
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
