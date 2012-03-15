require File.expand_path(File.join(File.dirname(__FILE__), '..', 'aws'))

module Fog
  module AWS
    class ElasticBeanstalk < Fog::Service

      class InvalidParameterError < Fog::Errors::Error; end

      requires :aws_access_key_id, :aws_secret_access_key

      request_path 'fog/aws/requests/beanstalk'

      request :check_dns_availability
      request :create_application
      request :create_application_version
      request :create_configuration_template
      request :create_environment
      request :create_storage_location
      request :delete_application
      request :delete_application_version
      request :delete_configuration_template
      request :delete_environment_configuration
      request :describe_applications
      request :describe_application_versions
      request :describe_configuration_options
      request :describe_configuration_settings
      request :describe_environment_resources
      request :describe_environments
      request :describe_events
      request :list_available_solution_stacks
      request :rebuild_environment
      request :request_environment_info
      request :restart_app_server
      request :retrieve_environment_info
      request :swap_environment_cnames
      request :terminate_environment
      request :update_application
      request :update_application_version
      request :update_configuration_template
      request :update_environment
      request :validate_configuration_settings

      model_path 'fog/aws/models/beanstalk'

      model       :application
      collection  :applications
      model       :environment
      collection  :environments
      model       :event
      collection  :events
      model       :template
      collection  :templates
      model       :version
      collection  :versions

      class Mock

        def initialize(options={})
          Fog::Mock.not_implemented
        end

      end

      class Real

        def initialize(options={})
          require 'fog/core/parser'
          require 'multi_json'

          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @hmac                   = Fog::HMAC.new('sha256', @aws_secret_access_key)

          @connection_options = options[:connection_options] || {}
          options[:region] ||= 'us-east-1'
          @host = options[:host] || "elasticbeanstalk.#{options[:region]}.amazonaws.com"
          @path       = options[:path]        || '/'
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        # Returns an array of available solutions stack details
        def solution_stacks
          list_available_solution_stacks.body['ListAvailableSolutionStacksResult']['SolutionStackDetails']
        end

        private

        def request(params)
          idempotent  = params.delete(:idempotent)
          parser      = params.delete(:parser)

          body = AWS.signed_params(
              params,
              {
                  :aws_access_key_id  => @aws_access_key_id,
                  :hmac               => @hmac,
                  :host               => @host,
                  :path               => @path,
                  :port               => @port,
                  :version            => '2010-12-01'
              }
          )

          begin
            response = @connection.request({
                                               :body       => body,
                                               :expects    => 200,
                                               :headers    => { 'Content-Type' => 'application/x-www-form-urlencoded' },
                                               :idempotent => idempotent,
                                               :host       => @host,
                                               :method     => 'POST',
                                               :parser     => parser
                                           })
          rescue Excon::Errors::HTTPStatusError => error
            if match = error.response.body.match(/<Code>(.*)<\/Code>[ \t\n]*<Message>(.*)<\/Message>/)
              raise case match[1].split('.').last
                      when 'InvalidParameterValue'
                        Fog::AWS::ElasticBeanstalk::InvalidParameterError.slurp(error, match[2])
                      else
                        Fog::AWS::ElasticBeanstalk::Error.slurp(error, "#{match[1]} => #{match[2]}")
                    end
            else
              raise error
            end
          end

        end
      end


    end
  end
end
