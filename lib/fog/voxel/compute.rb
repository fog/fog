require File.expand_path(File.join(File.dirname(__FILE__), '..', 'voxel'))
require 'fog/compute'

module Fog
  module Compute
    class Voxel < Fog::Service

      requires :voxel_api_key, :voxel_api_secret
      recognizes :host, :port, :scheme, :persistent

      model_path 'fog/voxel/models/compute'
      model       :image
      collection  :images
      model       :server
      collection  :servers

      request_path 'fog/voxel/requests/compute'
      request :images_list
      request :devices_list
      request :devices_power
      request :voxcloud_create
      request :voxcloud_status
      request :voxcloud_delete

      class Mock
        include Collections

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :last_modified => { :servers => {}, :statuses => {}, :images => {} },
              :servers => [],
              :statuses => {},
              :images  => [
                {'id' => 1,   'name' => "CentOS 4, 32-bit, base install"},
                {'id' => 2,   'name' => "CentOS 4, 64-bit, base install"},
                {'id' => 3,   'name' => "CentOS 5, 32-bit, base install"},
                {'id' => 4,   'name' => "CentOS 5, 64-bit, base install"},
                {'id' => 7,   'name' => "Fedora 10, 32-bit, base install"},
                {'id' => 8,   'name' => "Fedora 10, 64-bit, base install"},
                {'id' => 10,  'name' => "OpenSUSE 11, 64-bit, base install"},
                {'id' => 11,  'name' => "Debian 5.0 \"lenny\", 32-bit, base install"},
                {'id' => 12,  'name' => "Debian 5.0 \"lenny\", 64-bit, base install"},
                {'id' => 13,  'name' => "Ubuntu 8.04 \"Hardy\", 32-bit, base install"},
                {'id' => 14,  'name' => "Ubuntu 8.04 \"Hardy\", 64-bit, base install"},
                {'id' => 15,  'name' => "Voxel Server Environment (VSE), 32-bit, base install"},
                {'id' => 16,  'name' => "Voxel Server Environment (VSE), 64-bit, base install"},
                {'id' => 32,  'name' => "Pantheon Official Mercury Stack for Drupal (based on VSE/64)"},
                {'id' => 55,  'name' => "Ubuntu 10.04 \"Lucid\", 64-bit, base install"} ]
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @voxel_api_key = options[:voxel_api_key]
        end

        def data
          self.class.data[@voxel_api_key]
        end

        def reset_data
          self.class.data.delete(@voxel_api_key)
        end

      end

      class Real
        include Collections

        def initialize(options = {})
          require 'time'
          require 'digest/md5'

          @voxel_api_key = options[:voxel_api_key]
          @voxel_api_secret = options[:voxel_api_secret]

          @connection_options = options[:connection_options] || {}
          @host               = options[:host]    || "api.voxel.net"
          @port               = options[:port]    || 443
          @scheme             = options[:scheme]  || 'https'
          @persistent         = options[:persistent] || false

          Excon.ssl_verify_peer = false

          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def request(method_name, options = {})
          begin
            parser = options.delete(:parser)
            options.merge!({ :method => method_name, :timestamp => Time.now.xmlschema, :key => @voxel_api_key })
            options[:api_sig] = create_signature(@voxel_api_secret, options)
            data = @connection.request(
              :method => "POST",
              :query  => options,
              :parser => parser,
              :path   => "/version/1.0/"
            )
            unless data.body['stat'] == 'ok'
              raise Fog::Compute::Voxel::Error, "#{data.body['err']['msg']}"
            end
            data
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Compute::Voxel::NotFound.slurp(error)
            else
              error
            end
          end
        end

        def create_signature(secret, options)
          to_sign = options.keys.map { |k| k.to_s }.sort.map { |k| "#{k}#{options[k.to_sym]}" }.join("")
          Digest::MD5.hexdigest( secret + to_sign )
        end
      end
    end
  end
end
