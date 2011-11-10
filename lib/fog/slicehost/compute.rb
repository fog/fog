require File.expand_path(File.join(File.dirname(__FILE__), '..', 'slicehost'))
require 'fog/compute'

module Fog
  module Compute
    class Slicehost < Fog::Service

      requires :slicehost_password
      recognizes :host, :port, :scheme, :persistent

      model_path 'fog/slicehost/models/compute'
      model       :flavor
      collection  :flavors
      model       :image
      collection  :images
      model       :server
      collection  :servers

      request_path 'fog/slicehost/requests/compute'
      request :create_slice
      request :delete_slice
      request :get_backups
      request :get_flavor
      request :get_flavors
      request :get_image
      request :get_images
      request :get_slice
      request :get_slices
      request :reboot_slice

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
          @slicehost_password = options[:slicehost_password]
        end

        def data
          self.class.data[@slicehost_password]
        end

        def reset_data
          self.class.data.delete(@slicehost_password)
        end

      end

      class Real

        def initialize(options={})
          require 'fog/core/parser'

          @slicehost_password = options[:slicehost_password]
          @connection_options = options[:connection_options] || {}
          @host       = options[:host]        || "api.slicehost.com"
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params)
          params[:headers] ||= {}
          params[:headers].merge!({
            'Authorization' => "Basic #{Base64.encode64(@slicehost_password).delete("\r\n")}"
          })
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
              Fog::Compute::Slicehost::NotFound.slurp(error)
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
