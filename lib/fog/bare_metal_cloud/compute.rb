require File.expand_path(File.join(File.dirname(__FILE__), '..', 'bare_metal_cloud'))
require 'fog/compute'

module Fog
  module Compute
    class BareMetalCloud < Fog::Service

      requires :bare_metal_cloud_password, :bare_metal_cloud_username
      recognizes :host, :port, :scheme, :persistent

      model_path 'fog/bare_metal_cloud/models/compute'

      request_path 'fog/bare_metal_cloud/requests/compute'
      request :add_server
      request :cancel_server
      request :get_server
      request :list_images
      request :list_plans
      request :list_servers
      request :reboot_server

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @bare_metal_cloud_username = options[:bare_metal_cloud_username]
        end

        def data
          self.class.data[@bare_metal_cloud_username]
        end

        def reset_data
          self.class.data.delete(@bare_metal_cloud_username)
        end

      end

      class Real

        def initialize(options={})
          require 'fog/core/parser'

          @bare_metal_cloud_password = options[:bare_metal_cloud_password]
          @bare_metal_cloud_username = options[:bare_metal_cloud_username]
          @connection_options = options[:connection_options] || {}
          @host       = options[:host]        || "noc.baremetalcloud.com"
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params)
          params[:query] ||= {}
          params[:query].merge!({
            :password => @bare_metal_cloud_password,
            :username => @bare_metal_cloud_username
          })
          params[:headers] ||= {}
          case params[:method]
          when 'DELETE', 'GET', 'HEAD'
            params[:headers]['Accept'] = 'application/xml'
          when 'POST', 'PUT'
            params[:headers]['Content-Type'] = 'application/xml'
          end

          begin
            response = @connection.request(params.merge!({:host => @host}))
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Compute::BareMetalCloud::NotFound.slurp(error)
            else
              error
            end
          end

          response
        end

      end
    end
  end
end
