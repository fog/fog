require File.expand_path(File.join(File.dirname(__FILE__), '..', 'hp'))
require 'fog/cdn'

module Fog
  module CDN
    class HP < Fog::Service

      requires    :hp_secret_key, :hp_account_id
      recognizes  :hp_auth_uri, :hp_cdn_uri, :persistent, :connection_options

      model_path   'fog/hp/models/cdn'

      request_path 'fog/hp/requests/cdn'
      request :get_containers
      request :head_container
      request :post_container
      request :put_container
      request :delete_container

      module Utils
        # Take care of container names with '?' in them
        def escape_name(name)
          if name.include?('?')
            URI.escape(name).gsub('?', '%3F')
          else
            URI.escape(name)
          end
        end
      end

      class Mock
        include Utils

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
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
          @connection_options = options[:connection_options] || {}
          credentials = Fog::HP.authenticate(options, @connection_options)
          @auth_token = credentials['X-Auth-Token']
          @enabled = false
          @persistent = options[:persistent] || false
          hp_cdn_uri = options[:hp_cdn_uri] || "https://region-a.geo-1.cdnmgmt.hpcloudsvc.com"

          #TODO: Fix Storage service to return 'X-CDN-Management-Url' in the header as part of the auth call.
          # Till then use a custom config entry to get the CDN endpoint Url from user
          # and then append the auth path that comes back in the Storage Url to build the CDN Management Url
          # CDN Management Url looks like: https://cdnmgmt.hpcloud.net:8080/v1/AUTH_test
          cdn_mgmt_url = "#{hp_cdn_uri}#{URI.parse(credentials['X-Storage-Url']).path}"
          if cdn_mgmt_url
            uri = URI.parse(cdn_mgmt_url)
            @host   = uri.host
            @path   = uri.path
            @port   = uri.port
            @scheme = uri.scheme
            @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
            @enabled = true
          end
        end

        def enabled?
          @enabled
        end

        def reload
          @cdn_connection.reset
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
              Fog::Storage::HP::NotFound.slurp(error)
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
