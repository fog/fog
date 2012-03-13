module Fog
  module AWS
    class ElasticBeanstalk
      class Real

        require 'fog/aws/parsers/beanstalk/create_environment'

        # Launches an environment for the specified application using the specified configuration.
        #
        # ==== Options
        # * ApplicationName<~String>: If specified, AWS Elastic Beanstalk restricts the returned descriptions
        #   to include only those that are associated with this application.
        # * EnvironmentIds
        # * EnvironmentNames
        # * IncludeDeleted
        # * IncludedDeletedBackTo
        # * VersionLabel<~String>:
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/elasticbeanstalk/latest/api/API_CreateEnvironment.html
        #
        def create_environment(options={})
          if option_settings = options.delete('OptionSettings')
            options.merge!(AWS.indexed_param('OptionSettings.member.%d', [*option_settings]))
          end
          if options_to_remove = options.delete('OptionsToRemove')
            options.merge!(AWS.indexed_param('OptionsToRemove.member.%d', [*options_to_remove]))
          end
          request({
                      'Operation'    => 'CreateEnvironment',
                      :parser     => Fog::Parsers::AWS::ElasticBeanstalk::CreateEnvironment.new
                  }.merge(options))
        end
      end
    end
  end
end
