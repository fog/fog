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

    end
  end
end
