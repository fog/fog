require File.expand_path(File.join(File.dirname(__FILE__), '..', 'aws'))

module Fog
  module AWS
    class SES < Fog::Service

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :region, :host, :path, :port, :scheme, :persistent

      request_path 'fog/aws/requests/ses'
      request :delete_verified_email_address
      request :verify_email_address
      request :get_send_quota
      request :get_send_statistics
      request :list_verified_email_addresses
      request :send_email
      request :send_raw_email

      class Mock

        def initialize(options={})
          Fog::Mock.not_implemented
        end

      end

      class Real

        # Initialize connection to SES
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   ses = SES.new(
        #    :aws_access_key_id => your_aws_access_key_id,
        #    :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #   * region<~String> - optional region to use, in ['eu-west-1', 'us-east-1', 'us-west-1'i, 'ap-southeast-1']
        #
        # ==== Returns
        # * SES object with connection to AWS.
        def initialize(options={})
          require 'fog/core/parser'

          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @connection_options     = options[:connection_options] || {}
          @hmac = Fog::HMAC.new('sha256', @aws_secret_access_key)
          options[:region] ||= 'us-east-1'
          @host = options[:host] || case options[:region]
          when 'us-east-1'
            'email.us-east-1.amazonaws.com'
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

          headers = {
            'Content-Type'  => 'application/x-www-form-urlencoded',
            'Date'          => Fog::Time.now.to_date_header
          }

          #AWS3-HTTPS AWSAccessKeyId=<Your AWS Access Key ID>, Algorithm=HmacSHA256, Signature=<Signature>
          headers['X-Amzn-Authorization'] = 'AWS3-HTTPS '
          headers['X-Amzn-Authorization'] << 'AWSAccessKeyId=' << @aws_access_key_id
          headers['X-Amzn-Authorization'] << ', Algorithm=HmacSHA256'
          headers['X-Amzn-Authorization'] << ', Signature=' << Base64.encode64(@hmac.sign(headers['Date'])).chomp!

          body = ''
          for key in params.keys.sort
            unless (value = params[key]).nil?
              body << "#{key}=#{CGI.escape(value.to_s).gsub(/\+/, '%20')}&"
            end
          end
          body.chop! # remove trailing '&'

          response = @connection.request({
            :body       => body,
            :expects    => 200,
            :headers    => headers,
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
