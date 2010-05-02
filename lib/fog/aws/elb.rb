module Fog
  module AWS
    module ELB

      def self.new(options={})

        unless @required
          require 'fog/aws/requests/elb/describe_load_balancers'
          require 'fog/aws/parsers/elb/describe_load_balancers'
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
          when 'eu-west-1'
            'elasticloadbalancing.eu-west-1.amazonaws.com'
          when 'us-east-1'
            'elasticloadbalancing.us-east-1.amazonaws.com'
          when 'us-west-1'
            'elasticloadbalancing.us-west-1.amazonaws.com'
          when 'ap-southeast-1'
            'elasticloadbalancing.ap-southeast-1.amazonaws.com'
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

          params.merge!({
            'AWSAccessKeyId' => @aws_access_key_id,
            'SignatureMethod' => 'HmacSHA256',
            'SignatureVersion' => '2',
            'Timestamp' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ"),
            'Version' => '2009-11-25'
          })

          body = ''
          for key in params.keys.sort
            unless (value = params[key]).nil?
              body << "#{key}=#{CGI.escape(value.to_s).gsub(/\+/, '%20')}&"
            end
          end

          string_to_sign = "POST\n#{@host}\n/\n" << body.chop
          hmac = @hmac.update(string_to_sign)
          body << "Signature=#{CGI.escape(Base64.encode64(hmac.digest).chomp!).gsub(/\+/, '%20')}"

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
