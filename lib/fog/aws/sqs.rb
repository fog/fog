require File.expand_path(File.join(File.dirname(__FILE__), '..', 'aws'))

module Fog
  module AWS
    class SQS < Fog::Service

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :region, :host, :path, :port, :scheme, :persistent

      request_path 'fog/aws/requests/sqs'
      request :change_message_visibility
      request :create_queue
      request :delete_message
      request :delete_queue
      request :get_queue_attributes
      request :list_queues
      request :receive_message
      request :send_message
      request :set_queue_attributes

      class Mock
        def self.data
          @data ||= Hash.new do |hash, region|
            owner_id = Fog::AWS::Mock.owner_id
            hash[region] = Hash.new do |region_hash, key|
              region_hash[key] = {
                :owner_id => Fog::AWS::Mock.owner_id,
                :queues   => {}
              }
            end
          end
        end
        
        def self.reset
          @data = nil
        end

        def initialize(options={})
          @aws_access_key_id = options[:aws_access_key_id]

          @region = options[:region] || 'us-east-1'

          unless ['ap-northeast-1', 'ap-southeast-1', 'eu-west-1', 'us-east-1', 'us-west-1', 'us-west-2'].include?(@region)
            raise ArgumentError, "Unknown region: #{@region.inspect}"
          end
        end

        def data
          self.class.data[@region][@aws_access_key_id]
        end

        def reset_data
          self.class.data[@region].delete(@aws_access_key_id)
        end

      end

      class Real

        # Initialize connection to SQS
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   sqs = SQS.new(
        #    :aws_access_key_id => your_aws_access_key_id,
        #    :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #   * region<~String> - optional region to use, in ['eu-west-1', 'us-east-1', 'us-west-1', 'us-west-2', 'ap-southeast-1']
        #
        # ==== Returns
        # * SQS object with connection to AWS.
        def initialize(options={})
          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @connection_options     = options[:connection_options] || {}
          @hmac = Fog::HMAC.new('sha256', @aws_secret_access_key)
          options[:region] ||= 'us-east-1'
          @host = options[:host] || case options[:region]
          when 'ap-southeast-1'
            'ap-southeast-1.queue.amazonaws.com'
          when 'eu-west-1'
            'eu-west-1.queue.amazonaws.com'
          when 'us-east-1'
            'queue.amazonaws.com'
          when 'us-west-1'
            'us-west-1.queue.amazonaws.com'
          when 'us-west-2'
            'us-west-2.queue.amazonaws.com'
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

        def path_from_queue_url(queue_url)
          queue_url.split('.com', 2).last
        end

        def request(params)
          idempotent  = params.delete(:idempotent)
          parser      = params.delete(:parser)
          path        = params.delete(:path)

          body = AWS.signed_params(
            params,
            {
              :aws_access_key_id  => @aws_access_key_id,
              :hmac               => @hmac,
              :host               => @host,
              :path               => path || @path,
              :port               => @port,
              :version            => '2009-02-01'
            }
          )

          args = {
            :body       => body,
            :expects    => 200,
            :idempotent => idempotent,
            :headers    => { 'Content-Type' => 'application/x-www-form-urlencoded' },
            :host       => @host,
            :method     => 'POST',
            :parser     => parser
          }
          args.merge!(:path => path) if path

          response = @connection.request(args)

          response
        end

      end
    end
  end
end
