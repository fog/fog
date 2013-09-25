module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/create_topic'

        # Create a topic
        #
        # ==== Parameters
        # * name<~String> - Name of topic to create
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/sns/latest/api/API_CreateTopic.html
        #

        def create_topic(name)
          request({
            'Action'  => 'CreateTopic',
            'Name'    => name,
            :parser   => Fog::Parsers::AWS::SNS::CreateTopic.new
          })
        end

      end

      class Mock
        def create_topic(name)
          Excon::Response.new.tap do |response|
            response.status = 200
            now = Time.now
            topic_arn = Fog::AWS::Mock.arn('sns', 'us-east-1', data[:owner_id], name)
            topic = {
              'TopicName'      => name,
              'Attributes'     => {
                'CreatedTimestamp'                      => now,
                'LastModifiedTimestamp'                 => now,
                'TopicArn'                              => topic_arn
              },
              :messages        => {},
              :receipt_handles => {}
            }

            data[:topics][topic_arn] = topic unless data[:topics][topic_arn]

            response.body = {
              'ResponseMetadata' => {
                'RequestId' => Fog::AWS::Mock.request_id
              },
              'TopicArn' => topic_arn
            }
          end
        end
      end
    end
  end
end
