module Fog
  module AWS
    class ElasticBeanstalk
      class Real

        require 'fog/aws/parsers/beanstalk/create_application_version'

        # Launches an environment for the specified application using the specified configuration.
        #
        # ==== Options
        # * ApplicationName<~String>: If specified, AWS Elastic Beanstalk restricts the returned descriptions
        #   to include only those that are associated with this application.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/elasticbeanstalk/latest/api/API_CreateApplicationVersion.html
        #
        def create_application_version(options={})
          request({
                      'Operation'    => 'CreateApplicationVersion',
                      :parser     => Fog::Parsers::AWS::ElasticBeanstalk::CreateApplicationVersion.new
                  }.merge(options))
        end
      end
    end
  end
end
