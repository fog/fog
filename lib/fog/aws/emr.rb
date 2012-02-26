require File.expand_path(File.join(File.dirname(__FILE__), '..', 'aws'))

module Fog
  module AWS
    class EMR < Fog::Service

      class IdentifierTaken < Fog::Errors::Error; end

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :region, :host, :path, :port, :scheme, :persistent

      request_path 'fog/aws/requests/emr'

      request :add_instance_groups
      request :add_job_flow_steps
      request :describe_job_flows
      request :modify_instance_groups
      request :run_job_flow
      request :set_termination_protection
      request :terminate_job_flows

      # model_path 'fog/aws/models/rds'
      # model       :server
      # collection  :servers
      # model       :snapshot
      # collection  :snapshots
      # model       :parameter_group
      # collection  :parameter_groups
      #
      # model       :parameter
      # collection  :parameters
      #
      # model       :security_group
      # collection  :security_groups

      class Mock

        def initialize(options={})
          Fog::Mock.not_implemented
        end

      end

      class Real

        # Initialize connection to EMR
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   emr = EMR.new(
        #    :aws_access_key_id => your_aws_access_key_id,
        #    :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #   * region<~String> - optional region to use. For instance, in 'eu-west-1', 'us-east-1' and etc.
        #
        # ==== Returns
        # * EMR object with connection to AWS.
        def initialize(options={})
          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @connection_options     = options[:connection_options] || {}
          @hmac = Fog::HMAC.new('sha256', @aws_secret_access_key)

          options[:region] ||= 'us-east-1'
          @host = options[:host] || "elasticmapreduce.#{options[:region]}.amazonaws.com"
          @path       = options[:path]        || '/'
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
          @region = options[:region]
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
              :version            => '2009-03-31' #'2010-07-28'
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
            if match = error.message.match(/<Code>(.*)<\/Code>[\s\\\w]+<Message>(.*)<\/Message>/m)
              # case match[1].split('.').last
              # when 'DBInstanceNotFound', 'DBParameterGroupNotFound', 'DBSnapshotNotFound', 'DBSecurityGroupNotFound'
              #   raise Fog::AWS::RDS::NotFound.slurp(error, match[2])
              # when 'DBParameterGroupAlreadyExists'
              #   raise Fog::AWS::RDS::IdentifierTaken.slurp(error, match[2])
              # else
              #   raise
              # end
              raise
            else
              raise
            end
          end

          response
        end

      end
    end
  end
end
