module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/publish'

        # Send a message to a topic
        #
        # ==== Parameters
        # * arn<~String> - Arn of topic to send message to
        # * message<~String> - Message to send to topic
        # * options<~Hash>:
        #   * MessageStructure<~String> - message structure, in ['json']
        #   * Subject<~String> - value to use for subject when delivering by email
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/sns/latest/api/API_Publish.html
        #

        def publish(arn, message, options = {})
          request({
            'Action'    => 'Publish',
            'Message'   => message,
            'TopicArn'  => arn.strip,
            :parser     => Fog::Parsers::AWS::SNS::Publish.new
          }.merge!(options))
        end

      end

      class Mock

        def publish(arn, message, options = {})
          Excon::Response.new.tap do |response|
            if (topic = data[:topics][arn])
              response.status = 200

              now        = Time.now
              message_id = Fog::AWS::Mock.message_id
              md5        = Digest::MD5.hexdigest(message)

              queue[:messages][message_id] = {
                'MessageId'  => message_id,
                'Body'       => message,
                'MD5OfBody'  => md5,
                'Attributes' => {
                  'SenderId'      => Fog::AWS::Mock.message_id,
                  'SentTimestamp' => now
                }
              }

              queue['Attributes']['LastModifiedTimestamp'] = now

#<Excon::Response:0x00000007bac690 @data={:body=>{"MessageId"=>"6196d103-43eb-5761-aa1c-9bbe48eae574", "RequestId"=>"903392f1-fe8b-5501-b3e1-d84cf58aa714"}, :headers=>{"x-amzn-RequestId"=>"903392f1-fe8b-5501-b3e1-d84cf58aa714", "Content-Type"=>"text/xml", "Content-Length"=>"294", "Date"=>"Wed, 25 Sep 2013 16:01:05 GMT"}, :status=>200, :remote_ip=>"176.32.96.164"}, @body="", @headers={"x-amzn-RequestId"=>"903392f1-fe8b-5501-b3e1-d84cf58aa714", "Content-Type"=>"text/xml", "Content-Length"=>"294", "Date"=>"Wed, 25 Sep 2013 16:01:05 GMT"}, @status=200, @remote_ip="176.32.96.164">

              response.body = {
                'ResponseMetadata' => {
                  'RequestId' => Fog::AWS::Mock.request_id
                },
                'MessageId'        => message_id,
                'MD5OfMessageBody' => md5
              }
            else
              response.status = 404
              raise(Excon::Errors.status_error({:expects => 200}, response))
            end
          end
        end

      end

    end
  end
end
