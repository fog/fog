require 'fog/hp/core'

module Fog
  module HP
    class BlockStorageV2 < Fog::Service
      requires    :hp_access_key, :hp_secret_key, :hp_tenant_id, :hp_avl_zone
      recognizes  :hp_auth_uri, :credentials, :hp_service_type
      recognizes  :persistent, :connection_options
      recognizes  :hp_use_upass_auth_style, :hp_auth_version, :user_agent

      secrets     :hp_secret_key

      model_path  'fog/hp/models/block_storage_v2'
      model       :volume
      collection  :volumes
      model       :volume_backup
      collection  :volume_backups
      model       :snapshot
      collection  :snapshots

      request_path 'fog/hp/requests/block_storage_v2'
      request :create_volume
      request :delete_volume
      request :get_volume_details
      request :list_volumes
      request :list_volumes_detail
      request :update_volume
      request :create_snapshot
      request :delete_snapshot
      request :get_snapshot_details
      request :list_snapshots
      request :list_snapshots_detail
      request :update_snapshot
      request :create_volume_backup
      request :delete_volume_backup
      request :get_volume_backup_details
      request :list_volume_backups
      request :list_volume_backups_detail
      request :restore_volume_backup

      module Utils
        def compute
          @compute ||= Fog::Compute.new(
            :provider       => 'HP',
            :version        => :v2,
            :hp_access_key  => @hp_access_key,
            :hp_secret_key  => @hp_secret_key,
            :hp_auth_uri    => @hp_auth_uri,
            :hp_tenant_id   => @hp_tenant_id,
            :hp_avl_zone    => @hp_avl_zone,
            :credentials    => @credentials,
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
              :snapshots => {},
              :volume_backups => {}
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
        include Utils
        attr_reader :credentials

        def initialize(options={})
          @hp_access_key = options[:hp_access_key]
          @hp_secret_key = options[:hp_secret_key]
          @hp_auth_uri   = options[:hp_auth_uri]
          @connection_options = options[:connection_options] || {}
          ### Set an option to use the style of authentication desired; :v1 or :v2 (default)
          auth_version = options[:hp_auth_version] || :v2
          ### Pass the service name for block storage to the authentication call
          options[:hp_service_type] ||= "volume"
          @hp_tenant_id = options[:hp_tenant_id]
          @hp_avl_zone  = options[:hp_avl_zone]

          ### Make the authentication call
          if (auth_version == :v2)
            # Call the control services authentication
            credentials = Fog::HP.authenticate_v2(options, @connection_options)
            # the CS service catalog returns the block storage endpoint
            @hp_block_uri = credentials[:endpoint_url]
            @credentials = credentials
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
              :headers  => {
                'Content-Type' => 'application/json',
                'Accept'       => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :path     => "#{@path}/#{params[:path]}"
            }), &block)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::HP::BlockStorageV2::NotFound.slurp(error)
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
