module Fog
  module AWS
    module ELB

      def self.new(options={})

        unless @required
          require 'fog/aws/parsers/elb/deregister_instances_from_load_balancer'
          require 'fog/aws/parsers/elb/describe_instance_health'
          require 'fog/aws/parsers/elb/describe_load_balancers'
          require 'fog/aws/parsers/elb/disable_availability_zones_for_load_balancer'
          require 'fog/aws/parsers/elb/enable_availability_zones_for_load_balancer'
          require 'fog/aws/parsers/elb/register_instances_with_load_balancer'
          require 'fog/aws/requests/elb/deregister_instances_from_load_balancer'
          require 'fog/aws/requests/elb/describe_instance_health'
          require 'fog/aws/requests/elb/describe_load_balancers'
          require 'fog/aws/requests/elb/disable_availability_zones_for_load_balancer'
          require 'fog/aws/requests/elb/enable_availability_zones_for_load_balancer'
          require 'fog/aws/requests/elb/register_instances_with_load_balancer'
          @required = true
        end

        unless options[:aws_access_key_id]
          raise ArgumentError.new('aws_access_key_id is required to access elb')
        end
        unless options[:aws_secret_access_key]
          raise ArgumentError.new('aws_secret_access_key is required to access elb')
        end
        Fog::AWS::ELB::Real.new(options)
      end

      def self.indexed_param(key, values, idx_offset = 0)
        params = {}
        key.concat(".%") unless key.include?("%")
        [*values].each_with_index do |value, index|
          params["#{key.gsub("%", (index + idx_offset).to_s)}"] = value
        end
        return params
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
          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @hmac = HMAC::SHA256.new(@aws_secret_access_key)
          @host = options[:host] || case options[:region]
          when 'ap-southeast-1'
            'elasticloadbalancing.ap-southeast-1.amazonaws.com'
          when 'eu-west-1'
            'elasticloadbalancing.eu-west-1.amazonaws.com'
          when 'us-east-1'
            'elasticloadbalancing.us-east-1.amazonaws.com'
          when 'us-west-1'
            'elasticloadbalancing.us-west-1.amazonaws.com'
          else
            'elasticloadbalancing.amazonaws.com'
          end
          @port       = options[:port]      || 443
          @scheme     = options[:scheme]    || 'https'
        end

        private

        def request(params)
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")

          idempotent  = params.delete(:idempotent)
          parser      = params.delete(:parser)

          body = AWS.signed_params(
            params,
            {
              :aws_access_key_id  => @aws_access_key_id,
              :hmac               => @hmac,
              :host               => @host,
              :version            => '2009-11-25'
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
