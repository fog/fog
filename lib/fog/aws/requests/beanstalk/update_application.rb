module Fog
  module AWS
    class ElasticBeanstalk
      class Real

        require 'fog/aws/parsers/beanstalk/update_application'

        # Deletes the specified application along with all associated versions and configurations.
        #
        # ==== Options
        # * application_name<~String>: The name of the application.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/elasticbeanstalk/latest/api/API_UpdateApplication.html
        #
        def update_application(options)
          request({
                      'Operation'    => 'UpdateApplication',
                      :parser     => Fog::Parsers::AWS::ElasticBeanstalk::UpdateApplication.new
                  }.merge(options))
        end
      end
    end
  end
end
