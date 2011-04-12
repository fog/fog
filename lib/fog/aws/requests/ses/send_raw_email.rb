module Fog
  module AWS
    class SES
      class Real

        require 'fog/aws/parsers/ses/send_raw_email'

        # Send a raw email
        #
        # ==== Parameters
        # * RawMessage <~String> - The message to be sent.
        # * Options <~Hash>
        #   * Source <~String> - The sender's email address. Takes precenence over Return-Path if specified in RawMessage
        # * Destination <~Hash> - The destination for this email, composed of To:, From:, and CC: fields.
        #   * BccAddresses <~Array> - The BCC: field(s) of the message.
        #   * CcAddresses <~Array> - The CC: field(s) of the message.
        #   * ToAddresses <~Array> - The To: field(s) of the message.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'MessageId'<~String> - Id of message
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def send_raw_email(raw_message, options = {})
          params = {}
          if options.has_key?('Destinations')
            for key, values in options['Destinations']
              params.merge!(AWS.indexed_param("Destination.#{key}.member", [*values]))
            end
          end
          if options.has_key?('Source')
            params['Source'] = options['Source']
          end

          request({
            'Action'          => 'SendRawEmail',
            'RawMessage.Data' => Base64.encode64(raw_message).chomp!,
            :parser           => Fog::Parsers::AWS::SES::SendRawEmail.new
          }.merge(params))
        end

      end
    end
  end
end
