module Fog
  module AWS
    class SES
      class Real

        require 'fog/aws/parsers/ses/send_raw_email'

        # Delete an existing verified email address
        #
        # ==== Parameters
        # * RawMessage <~String> - The message to be sent.
        # * Options <~Hash>
        #   * Source <~String> - The sender's email address
        #   * Destinations <~Array> - The destination for this email, composed of To:, From:, and CC: fields.
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
            params['Destinations'] = AWS.indexed_param('Destinations.member', [*options['Destinations']])
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
