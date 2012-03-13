module Fog
  module AWS
    class ElasticBeanstalk
      class Real

        require 'fog/aws/parsers/beanstalk/describe_events'

        # Returns descriptions for existing environments.
        #
        # ==== Options
        # * ApplicationName<~String>: If specified, AWS Elastic Beanstalk restricts the returned descriptions
        #   to include only those that are associated with this application.
        # ==== Returns
        # * response<~Excon::Response>:
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/elasticbeanstalk/latest/api/API_DescribeEnvironments.html
        #
        def describe_events(options={})
          request({
                      'Operation'    => 'DescribeEvents',
                      :parser     => Fog::Parsers::AWS::ElasticBeanstalk::DescribeEvents.new
                  }.merge(options))
        end
      end
    end
  end
end
