require File.expand_path(File.join(File.dirname(__FILE__), '..', 'aws'))

module Fog
  module AWS
    class DynamoDB < Fog::Service

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :aws_session_token, :host, :path, :port, :scheme, :persistent, :region

      request_path 'fog/aws/requests/dynamodb'
      request :batch_get_item
      request :create_table
      request :delete_item
      request :delete_table
      request :describe_table
      request :get_item
      request :list_tables
      request :put_item
      request :query
      request :scan
      request :update_item
      request :update_table

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :domains => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @aws_access_key_id = options[:aws_access_key_id]
        end

        def data
          self.class.data[@aws_access_key_id]
        end

        def reset_data
          self.class.data.delete(@aws_access_key_id)
        end

      end

      class Real

        # Initialize connection to DynamoDB
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   ddb = DynamoDB.new(
        #     :aws_access_key_id => your_aws_access_key_id,
        #     :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #
        # ==== Returns
        # * DynamoDB object with connection to aws
        def initialize(options={})
          require 'multi_json'

          if options[:aws_session_token]
            @aws_access_key_id      = options[:aws_access_key_id]
            @aws_secret_access_key  = options[:aws_secret_access_key]
            @aws_session_token      = options[:aws_session_token]
          else
            sts = Fog::AWS::STS.new(
              :aws_access_key_id      => options[:aws_access_key_id],
              :aws_secret_access_key  => options[:aws_secret_access_key]
            )
            session_data = sts.get_session_token.body

            @aws_access_key_id      = session_data['AccessKeyId']
            @aws_secret_access_key  = session_data['SecretAccessKey']
            @aws_session_token      = session_data['SessionToken']
          end
          @connection_options     = options[:connection_options] || {}
          @hmac       = Fog::HMAC.new('sha256', @aws_secret_access_key)

          options[:region] ||= 'us-east-1'
          @host = options[:host] || "dynamodb.#{options[:region]}.amazonaws.com"
          @path       = options[:path]        || '/'
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || '80' #443
          @scheme     = options[:scheme]      || 'http' #'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
        end

        private

        def reload
          @connection.reset
        end

        def request(params)
          idempotent = params.delete(:idempotent)

          now = Fog::Time.now
          headers = {
            'Content-Type'          => 'application/x-amz-json-1.0',
            'x-amz-date'            => Fog::Time.now.to_date_header,
            'x-amz-security-token'  => @aws_session_token
          }.merge(params[:headers])
          headers['x-amzn-authorization']  = signed_authorization_header(params, headers)

          response = @connection.request({
            :body       => params[:body],
            :expects    => 200,
            :headers    => headers,
            :host       => @host,
            :idempotent => idempotent,
            :method     => 'POST',
          })

          unless response.body.empty?
            response.body = MultiJson.decode(response.body)
          end

          response
        end

        def signed_authorization_header(params, headers)
          string_to_sign = "POST\n/\n\nhost:#{@host}:#{@port}\n"

          amz_headers, canonical_amz_headers = {}, ''
          for key, value in headers
            if key[0..5] == 'x-amz-'
              amz_headers[key] = value
            end
          end
          amz_headers = amz_headers.sort {|x, y| x[0] <=> y[0]}
          for key, value in amz_headers
            canonical_amz_headers << "#{key}:#{value}\n"
          end
          string_to_sign << canonical_amz_headers
          string_to_sign << "\n"
          string_to_sign << (params[:body] || '')

          string_to_sign = OpenSSL::Digest::SHA256.digest(string_to_sign)

          signed_string = @hmac.sign(string_to_sign)
          signature = Base64.encode64(signed_string).chomp!

          "AWS3 AWSAccessKeyId=#{@aws_access_key_id},Algorithm=HmacSHA256,Signature=#{signature}"
        end

      end
    end
  end
end
