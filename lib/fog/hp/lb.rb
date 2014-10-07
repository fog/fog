require 'fog/hp/core'

module Fog
  module HP
    class LB < Fog::Service
      requires    :hp_access_key, :hp_secret_key, :hp_tenant_id, :hp_avl_zone
      recognizes  :hp_auth_uri, :credentials, :hp_service_type
      recognizes  :persistent, :connection_options
      recognizes  :hp_use_upass_auth_style, :hp_auth_version, :user_agent

      secrets :hp_secret_key

      model_path 'fog/hp/models/lb'
      model       :algorithm
      collection  :algorithms
      model       :load_balancer
      collection  :load_balancers
      model       :node
      collection  :nodes
      model       :protocol
      collection  :protocols
      model       :virtual_ip
      collection  :virtual_ips

      request_path 'fog/hp/requests/lb'
      request       :create_load_balancer
      request       :create_load_balancer_node
      request       :delete_load_balancer
      request       :delete_load_balancer_node
      request       :get_load_balancer
      request       :get_load_balancer_node
      request       :list_algorithms
      request       :list_limits
      request       :list_load_balancer_nodes
      request       :list_load_balancer_virtual_ips
      request       :list_load_balancers
      request       :list_protocols
      request       :list_versions
      request       :update_load_balancer
      request       :update_load_balancer_node

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
                :versions => {
                  "v1.1" => { "id" => "v1.1",
                              "links" => [{"href" => "http://api-docs.hpcloud.com", "rel" => "self"}],
                              "status" => "CURRENT",
                              "updated" => "2012-12-18T18:30:02.25Z"
                  }
                },
                :limits => {
                  "absolute" => {
                    "values" => {
                      "maxLoadBalancerNameLength" => 128,
                      "maxLoadBalancers"          => 20,
                      "maxNodesPerLoadBalancer"   => 5,
                      "maxVIPsPerLoadBalancer"    => 1
                    }
                  }
                },
                :lbs => {},
                :protocols => {
                  "HTTP" => { "name" => "HTTP", "port" => 80 },
                  "TCP"  => { "name" => "TCP", "port"  => 443 }
                },
                :algorithms => {
                  "ROUND_ROBIN"       => { "name" => "ROUND_ROBIN" },
                  "LEAST_CONNECTIONS" => { "name" => "LEAST_CONNECTIONS"}
                }
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @hp_access_key = options[:hp_access_key]
        end

        def data
          self.class.data[@hp_access_key]
        end

        def reset_data
          self.class.data.delete(@hp_access_key)
        end
      end

      class Real
        attr_reader :credentials

        def initialize(options={})
          @hp_access_key = options[:hp_access_key]
          @hp_secret_key      = options[:hp_secret_key]
          @hp_auth_uri        = options[:hp_auth_uri]
          @connection_options = options[:connection_options] || {}
          ### Set an option to use the style of authentication desired; :v1 or :v2 (default)
          auth_version        = options[:hp_auth_version] || :v2
          ### Pass the service name for object storage to the authentication call
          options[:hp_service_type] ||= "hpext:lbaas"
          @hp_tenant_id       = options[:hp_tenant_id]
          @hp_avl_zone        = options[:hp_avl_zone]

          ### Make the authentication call
          if (auth_version == :v2)
            # Call the control services authentication
            credentials = Fog::HP.authenticate_v2(options, @connection_options)
            # the CS service catalog returns the block storage endpoint
            @hp_block_uri = credentials[:endpoint_url]
          else
            # Call the legacy v1.0/v1.1 authentication
            credentials = Fog::HP.authenticate_v1(options, @connection_options)
            # the user sends in the block storage endpoint
            @hp_block_uri = options[:hp_auth_uri]
          end

          @auth_token = credentials[:auth_token]
          @persistent = options[:persistent] || false

          uri = URI.parse(@hp_block_uri)
          @host   = uri.host
          @path   = uri.path
          @port   = uri.port
          @scheme = uri.scheme

          @connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params, parse_json = true, &block)
          begin
            response = @connection.request(params.merge!({
               :headers => {
                 'Content-Type' => 'application/json',
                 'Accept'       => 'application/json',
                 'X-Auth-Token' => @auth_token
               }.merge!(params[:headers] || {}),
               :path    => "#{@path}/#{params[:path]}",
           }), &block)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::HP::LB::NotFound.slurp(error)
            else
              error
            end
          end
          if !response.body.empty? && parse_json && response.headers['Content-Type'] =~ %r{application/json}
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end
      end
    end
  end
end
