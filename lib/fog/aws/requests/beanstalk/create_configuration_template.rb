module Fog
  module AWS
    class ElasticBeanstalk
      class Real

        require 'fog/aws/parsers/beanstalk/create_configuration_template'

        # Creates a configuration template. Templates are associated with a specific application and are used to
        # deploy different versions of the application with the same configuration settings.
        #
        # ==== Options
        # * ApplicationName<~String>: If specified, AWS Elastic Beanstalk restricts the returned descriptions
        #   to include only those that are associated with this application.
        # * VersionLabel<~String>:
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/elasticbeanstalk/latest/api/API_CreateConfigurationTemplate.html
        #
        def create_configuration_template(options={})
          if option_settings = options.delete('OptionSettings')
            options.merge!(AWS.indexed_param('OptionSettings.member.%d', [*option_settings]))
          end
          request({
                      'Operation'    => 'CreateConfigurationTemplate',
                      :parser     => Fog::Parsers::AWS::ElasticBeanstalk::CreateConfigurationTemplate.new
                  }.merge(options))
        end
      end
    end
  end
end
