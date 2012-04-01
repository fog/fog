require File.expand_path(File.join(File.dirname(__FILE__), '..', 'aws'))
# require 'fog/compute'

module Fog
  module AWS
    class VPC < Fog::Service

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :endpoint, :region, :host, :path, :port, :scheme, :persistent

      model_path 'fog/aws/models/vpc'
      model       :vpc
      collection  :vpcs
      # model       :subnet
      # collection  :subnets
      # model       :routetable
      # collection  :routetables
      # model       :internetgateway
      # collection  :internetgateways
      # model       :dhcpoptionset
      # collection  :dhcpoptionsets
      # model       :elasticip
      # collection  :elasticips
      # model       :networkacl
      # collection  :networkacls
      # model       :securitygroup
      # collection  :securitygroups
      # model       :customergateway
      # collection  :customergateways
      # model       :virtualprivategateway
      # collection  :virtualprivategateways
      # model       :vpnconnection
      # collection  :vpnconnections

      request_path 'fog/aws/requests/vpc'
      request :create_vpc
      request :delete_vpc
      request :describe_vpcs
      # request :create_subnet
      # request :delete_subnet
      # request :describe_subnets
      # request :create_routetable
      # request :get_routetable
      # request :delete_routetable
      # request :list_routetables
      # request :create_internetgateway
      # request :get_internetgateway
      # request :delete_internetgateway
      # request :list_internetgateways
      # request :create_dhcpoptionset
      # request :get_dhcpoptionset
      # request :delete_dhcpoptionset
      # request :list_dhcpoptionsets
      # request :create_elasticip
      # request :get_elasticip
      # request :delete_elasticip
      # request :list_elasticips
      # request :create_networkacl
      # request :get_networkacl
      # request :delete_networkacl
      # request :list_networkacls
      # request :create_securitygroup
      # request :get_securitygroup
      # request :delete_securitygroup
      # request :list_securitygroups
      # request :create_customergateway
      # request :get_customergateway
      # request :delete_customergateway
      # request :list_customergateways
      # request :create_virtualprivategateway
      # request :get_virtualprivategateway
      # request :delete_virtualprivategateway
      # request :list_virtualprivategateways
      # request :create_vpnconnection
      # request :get_vpnconnection
      # request :delete_vpnconnection
      # request :list_vpnconnections

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

        # Initialize connection to VPC service
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   vpc = Fog::AWS::VPC.new(
        #     :aws_access_key_id => your_aws_access_key_id,
        #     :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #   * region<~String> - optional region to use, in
        #     ['eu-west-1', 'us-east-1', 'us-west-1', 'ap-northeast-1', 'ap-southeast-1']
        #
        # ==== Returns
        # * vpc object with connection to aws.
        def initialize(options={})
          require 'fog/core/parser'

          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @connection_options     = options[:connection_options] || {}
          @hmac                   = Fog::HMAC.new('sha256', @aws_secret_access_key)
          @region                 = options[:region] ||= 'us-east-1'

          if @endpoint = options[:endpoint]
            endpoint = URI.parse(@endpoint)
            @host = endpoint.host
            @path = endpoint.path
            @port = endpoint.port
            @scheme = endpoint.scheme
          else
            @host = options[:host] || case options[:region]
            when 'ap-northeast-1'
              'ec2.ap-northeast-1.amazonaws.com'
            when 'ap-southeast-1'
              'ec2.ap-southeast-1.amazonaws.com'
            when 'eu-west-1'
              'ec2.eu-west-1.amazonaws.com'
            when 'us-east-1'
              'ec2.us-east-1.amazonaws.com'
            when 'us-west-1'
              'ec2.us-west-1.amazonaws.com'
            else
              raise ArgumentError, "Unknown region: #{options[:region].inspect}"
            end
            @path       = options[:path]        || '/'
            @persistent = options[:persistent]  || false
            @port       = options[:port]        || 443
            @scheme     = options[:scheme]      || 'https'
          end
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
              :version            => '2011-07-15'
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
            if match = error.message.match(/<Code>(.*)<\/Code><Message>(.*)<\/Message>/)
              raise case match[1].split('.').last
              when 'NotFound', 'Unknown'
                Fog::Compute::AWS::NotFound.slurp(error, match[2])
              else
                Fog::Compute::AWS::Error.slurp(error, "#{match[1]} => #{match[2]}")
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
