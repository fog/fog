module Fog
  module AWS
    class ELB < Fog::Service

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :region, :host, :path, :port, :scheme, :persistent

      request_path 'fog/aws/requests/elb'
      request :configure_health_check
      request :create_app_cookie_stickiness_policy
      request :create_lb_cookie_stickiness_policy
      request :create_load_balancer
      request :create_load_balancer_listeners
      request :delete_load_balancer
      request :delete_load_balancer_listeners
      request :delete_load_balancer_policy
      request :deregister_instances_from_load_balancer
      request :describe_instance_health
      request :describe_load_balancers
      request :disable_availability_zones_for_load_balancer
      request :enable_availability_zones_for_load_balancer
      request :register_instances_with_load_balancer
      #request :set_load_balancer_listener_ssl_certificate
      request :set_load_balancer_policies_of_listener

      class Mock

        def initialize(options={})
        end

      end

      class Real

        # Initialize connection to ELB
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   elb = ELB.new(
        #    :aws_access_key_id => your_aws_access_key_id,
        #    :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #   * region<~String> - optional region to use, in ['eu-west-1', 'us-east-1', 'us-west-1'i, 'ap-southeast-1']
        #
        # ==== Returns
        # * ELB object with connection to AWS.
        def initialize(options={})
          require 'fog/core/parser'

          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @hmac = Fog::HMAC.new('sha256', @aws_secret_access_key)

          options[:region] ||= 'us-east-1'
          @host = options[:host] || case options[:region]
          when 'ap-northeast-1'
            'elasticloadbalancing.ap-northeast-1.amazonaws.com'
          when 'ap-southeast-1'
            'elasticloadbalancing.ap-southeast-1.amazonaws.com'
          when 'eu-west-1'
            'elasticloadbalancing.eu-west-1.amazonaws.com'
          when 'us-east-1'
            'elasticloadbalancing.us-east-1.amazonaws.com'
          when 'us-west-1'
            'elasticloadbalancing.us-west-1.amazonaws.com'
          else
            raise ArgumentError, "Unknown region: #{options[:region].inspect}"
          end
          @path       = options[:path]      || '/'
          @port       = options[:port]      || 443
          @scheme     = options[:scheme]    || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", options[:persistent])
        end

        def reload
          @connection.reset
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
              :version            => '2010-07-01'
            }
          )

          response = @connection.request({
            :body       => body,
            :expects    => 200,
            :headers    => { 'Content-Type' => 'application/x-www-form-urlencoded' },
            :idempotent => idempotent,
            :host       => @host,
            :method     => 'POST',
            :parser     => parser
          })

          response
        end

      end
    end
  end
end
