require File.expand_path(File.join(File.dirname(__FILE__), '..', 'aws'))
require 'fog/dns'

module Fog
  module DNS
    class AWS < Fog::Service

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :host, :path, :port, :scheme, :version, :persistent

      model_path 'fog/aws/models/dns'
      model       :record
      collection  :records
      model       :zone
      collection  :zones

      request_path 'fog/aws/requests/dns'
      request :create_hosted_zone
      request :get_hosted_zone
      request :delete_hosted_zone
      request :list_hosted_zones
      request :change_resource_record_sets
      request :list_resource_record_sets
      request :get_change

      class Mock

        def self.data
          @data ||= Hash.new do |hash, region|
            hash[region] = Hash.new do |region_hash, key|
              region_hash[key] = {
                :buckets => {}
              }
            end
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          require 'mime/types'
          @aws_access_key_id  = options[:aws_access_key_id]
          @region             = options[:region]
        end

        def data
          self.class.data[@region][@aws_access_key_id]
        end

        def reset_data
          self.class.data[@region].delete(@aws_access_key_id)
        end

        def signature(params)
          "foo"
        end
      end

      class Real

        # Initialize connection to Route 53 DNS service
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   dns = Fog::AWS::DNS.new(
        #     :aws_access_key_id => your_aws_access_key_id,
        #     :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #
        # ==== Returns
        # * dns object with connection to aws.
        def initialize(options={})
          require 'fog/core/parser'

          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @connection_options     = options[:connection_options] || {}
          @hmac       = Fog::HMAC.new('sha1', @aws_secret_access_key)
          @host       = options[:host]        || 'route53.amazonaws.com'
          @path       = options[:path]        || '/'
          @persistent = options[:persistent]  || true
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @version    = options[:version]     || '2010-10-01'

          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        private

        def request(params, &block)
          params[:headers] ||= {}
          params[:headers]['Date'] = Fog::Time.now.to_date_header
          params[:headers]['X-Amzn-Authorization'] = "AWS3-HTTPS AWSAccessKeyId=#{@aws_access_key_id},Algorithm=HmacSHA1,Signature=#{signature(params)}"
          params[:path] = "/#{@version}/#{params[:path]}" 
          @connection.request(params, &block)
        end

        def signature(params)
          string_to_sign = params[:headers]['Date']
          signed_string = @hmac.sign(string_to_sign)
          signature = Base64.encode64(signed_string).chomp!
        end
      end
    end
  end
end
