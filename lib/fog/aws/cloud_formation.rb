require File.expand_path(File.join(File.dirname(__FILE__), '..', 'aws'))

module Fog
  module AWS
    class CloudFormation < Fog::Service

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :host, :path, :port, :scheme, :persistent, :region

      request_path 'fog/aws/requests/cloud_formation'
      request :create_stack
      request :update_stack
      request :delete_stack
      request :describe_stack_events
      request :describe_stack_resources
      request :describe_stacks
      request :get_template
      request :validate_template

      class Mock

        def initialize(options={})
          Fog::Mock.not_implemented
        end

      end

      class Real

        # Initialize connection to CloudFormation
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   cf = CloudFormation.new(
        #    :aws_access_key_id => your_aws_access_key_id,
        #    :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #
        # ==== Returns
        # * CloudFormation object with connection to AWS.
        def initialize(options={})
          require 'fog/core/parser'
          require 'multi_json'

          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @hmac       = Fog::HMAC.new('sha256', @aws_secret_access_key)

          @connection_options = options[:connection_options] || {}
          options[:region] ||= 'us-east-1'
          @host = options[:host] || case options[:region]
          when 'ap-northeast-1'
            'cloudformation.ap-northeast-1.amazonaws.com'
          when 'ap-southeast-1'
            'cloudformation.ap-southeast-1.amazonaws.com'
          when 'eu-west-1'
            'cloudformation.eu-west-1.amazonaws.com'
          when 'us-east-1'
            'cloudformation.us-east-1.amazonaws.com'
          when 'us-west-1'
            'cloudformation.us-west-1.amazonaws.com'
          when 'us-west-2'
            'cloudformation.us-west-2.amazonaws.com'
          else
            raise ArgumentError, "Unknown region: #{options[:region].inspect}"
          end
          @path       = options[:path]        || '/'
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        private

        def request(params)
          idempotent  = params.delete(:idempotent)
          parser      = params.delete(:parser)

          body = Fog::AWS.signed_params(
            params,
            {
              :aws_access_key_id  => @aws_access_key_id,
              :hmac               => @hmac,
              :host               => @host,
              :path               => @path,
              :port               => @port,
              :version            => '2010-05-15'
            }
          )

          begin
            response = @connection.request({
              :body       => body,
              :expects    => 200,
              :idempotent => idempotent,
              :headers    => { 'Content-Type' => 'application/x-www-form-urlencoded' },
              :host       => @host,
              :method     => 'POST',
              :parser     => parser
            })
          rescue Excon::Errors::HTTPStatusError => error
            if match = error.message.match(/<Code>(.*)<\/Code><Message>(.*)<\/Message>/)
              raise case match[1].split('.').last
              when 'NotFound'
                Fog::AWS::Compute::NotFound.slurp(error, match[2])
              else
                Fog::AWS::Compute::Error.slurp(error, "#{match[1]} => #{match[2]}")
              end
            else
              raise error
            end
          end

          response
        end

      end
    end
  end
end
