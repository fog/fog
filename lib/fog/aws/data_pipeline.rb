require 'fog/aws/core'

module Fog
  module AWS
    class DataPipeline < Fog::Service
      extend Fog::AWS::CredentialFetcher::ServiceMethods

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :region, :host, :path, :port, :scheme, :persistent, :use_iam_profile, :aws_session_token, :aws_credentials_expire_at, :instrumentor, :instrumentor_name

      request_path 'fog/aws/requests/data_pipeline'
      request :activate_pipeline
      request :create_pipeline
      request :delete_pipeline
      request :describe_pipelines
      request :list_pipelines
      request :put_pipeline_definition
      request :get_pipeline_definition
      request :query_objects
      request :describe_objects

      model_path 'fog/aws/models/data_pipeline'
      model       :pipeline
      collection  :pipelines

      class Mock
        def initialize(options={})
          Fog::Mock.not_implemented
        end
      end

      class Real
        attr_reader :region

        include Fog::AWS::CredentialFetcher::ConnectionMethods
        # Initialize connection to DataPipeline
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   datapipeline = DataPipeline.new(
        #    :aws_access_key_id => your_aws_access_key_id,
        #    :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #   * region<~String> - optional region to use. For instance, 'eu-west-1', 'us-east-1' and etc.
        #
        # ==== Returns
        # * DataPipeline object with connection to AWS.
        def initialize(options={})
          @use_iam_profile = options[:use_iam_profile]
          @instrumentor       = options[:instrumentor]
          @instrumentor_name  = options[:instrumentor_name] || 'fog.aws.data_pipeline'
          @connection_options     = options[:connection_options] || {}
          @version    = '2012-10-29'
          @region     = options[:region]      || 'us-east-1'
          @host       = options[:host]        || "datapipeline.#{@region}.amazonaws.com"
          @path       = options[:path]        || '/'
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)

          setup_credentials(options)
        end

        def owner_id
          @owner_id ||= security_groups.get('default').owner_id
        end

        def reload
          @connection.reset
        end

        private

        def setup_credentials(options)
          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @aws_session_token     = options[:aws_session_token]
          @aws_credentials_expire_at = options[:aws_credentials_expire_at]

          @signer = Fog::AWS::SignatureV4.new(@aws_access_key_id, @aws_secret_access_key, @region, 'datapipeline')
        end

        def request(params)
          refresh_credentials_if_expired

          # Params for all DataPipeline requests
          params.merge!({
            :expects => 200,
            :method => :post,
            :path => '/',
          })

          date = Fog::Time.now
          params[:headers] = {
            'Date' => date.to_date_header,
            'Host' => @host,
            'X-Amz-Date' => date.to_iso8601_basic,
            'Content-Type' => 'application/x-amz-json-1.1',
            'Content-Length' => params[:body].bytesize.to_s,
          }.merge!(params[:headers] || {})
          params[:headers]['x-amz-security-token'] = @aws_session_token if @aws_session_token
          params[:headers]['Authorization'] = @signer.sign(params, date)

          if @instrumentor
            @instrumentor.instrument("#{@instrumentor_name}.request", params) do
              _request(params)
            end
          else
            _request(params)
          end
        end

        def _request(params)
          @connection.request(params)
        end
      end
    end
  end
end
