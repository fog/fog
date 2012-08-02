require File.expand_path(File.join(File.dirname(__FILE__), '..', 'hp'))
require 'fog/block_storage'

module Fog
  module BlockStorage
    class HP < Fog::Service

      requires    :hp_secret_key, :hp_account_id, :hp_tenant_id, :hp_avl_zone
      recognizes  :hp_auth_uri, :persistent, :connection_options, :hp_use_upass_auth_style, :hp_auth_version

      model_path   'fog/hp/models/block_storage'
      model       :volume
      collection  :volumes

      request_path 'fog/hp/requests/block_storage'
      request :create_volume
      request :delete_volume
      request :get_volume_details
      request :list_volumes

      request :create_snapshot
      request :list_snapshots
      request :get_snapshot_details

      module Utils

        def compute
          @compute ||= Fog::Compute.new(
            :provider       => 'HP',
            :hp_account_id  => @hp_account_id,
            :hp_secret_key  => @hp_secret_key,
            :hp_auth_uri    => @hp_auth_uri,
            :hp_tenant_id   => @hp_tenant_id,
            :hp_avl_zone    => @hp_avl_zone,
            :connection_options => @connection_options
          )
        end

      end

      class Mock
        include Utils

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :volumes => {},
              :snapshots => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @hp_account_id = options[:hp_account_id]
        end

        def data
          self.class.data[@hp_account_id]
        end

        def reset_data
          self.class.data.delete(@hp_account_id)
        end

      end

      class Real
        include Utils

        def initialize(options={})
          require 'multi_json'
          @hp_secret_key = options[:hp_secret_key]
          @hp_account_id = options[:hp_account_id]
          @hp_auth_uri   = options[:hp_auth_uri]
          @connection_options = options[:connection_options] || {}
          ### Set an option to use the style of authentication desired; :v1 or :v2 (default)
          auth_version = options[:hp_auth_version] || :v2
          ### Pass the service name for object storage to the authentication call
          options[:hp_service_type] = "Block Storage"
          @hp_tenant_id = options[:hp_tenant_id]
          @hp_avl_zone  = options[:hp_avl_zone]

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

          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params, parse_json = true, &block)
          begin
            response = @connection.request(params.merge!({
              :headers  => {
                'Content-Type' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :host     => @host,
              :path     => "#{@path}/#{params[:path]}",
            }), &block)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::BlockStorage::HP::NotFound.slurp(error)
            else
              error
            end
          end
          if !response.body.empty? && parse_json && response.headers['Content-Type'] =~ %r{application/json}
            response.body = MultiJson.decode(response.body)
          end
          response
        end

      end
    end
  end
end
