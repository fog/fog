require File.expand_path(File.join(File.dirname(__FILE__), '..', 'brightbox'))
require 'fog/compute'
require 'multi_json'

module Fog
  module Compute
    class Joyent < Fog::Service
      requires :joyent_username

      recognizes :joyent_password
      recognizes :joyent_url
      recognizes :joyent_keyname
      recognizes :joyent_keyfile

      model_path 'fog/joyent/models/compute'
      request_path 'fog/joyent/requests/compute'

      # request :list_datacenters
      # request :get_datacenter

      # Keys
      collection :keys
      model :key

      request :list_keys
      request :get_key
      request :create_key
      request :delete_key

      # Images
      collection :images
      model :image
      request :list_datasets
      request :get_dataset

      # Flavors
      collection :flavors
      model :flavor
      request :list_packages
      request :get_package

      # Servers
      collection :servers
      model :server
      request :list_machines
      request :get_machine
      request :create_machine
      request :start_machine
      request :stop_machine
      request :reboot_machine
      request :resize_machine
      request :delete_machine

      # Snapshots
      collection :snapshots
      model :snapshot
      request :create_machine_snapshot
      request :start_machine_from_snapshot
      request :list_machine_snapshots
      request :get_machine_snapshot
      request :delete_machine_snapshot
      request :update_machine_metadata
      request :get_machine_metadata
      request :delete_machine_metadata
      request :delete_all_machine_metadata

      # MachineTags
      request :add_machine_tags
      request :list_machine_tags
      request :get_machine_tag
      request :delete_machine_tag
      request :delete_all_machine_tags

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def data
          self.class.data
        end

        def initialize(options = {})
          @joyent_username = options[:joyent_username] || Fog.credentials[:joyent_username]
          @joyent_password = options[:joyent_password] || Fog.credentials[:joyent_password]
        end

        def request(opts)
          raise "Not Implemented"
        end
      end # Mock

      class Real
        def initialize(options = {})
          @connection_options = options[:connection_options] || {}
          @persistent = options[:persistent] || false

          @joyent_url = options[:joyent_url] || 'https://us-sw-1.api.joyentcloud.com'
          @joyent_version = options[:joyent_version] || '~6.5'

          @joyent_username = options[:joyent_username]

          unless @joyent_username
            raise ArgumentError, "options[:joyent_username] required"
          end

          if options[:joyent_keyname] && options[:joyent_keyfile]
            if File.exists?(options[:joyent_keyfile])
              @joyent_keyname = options[:joyent_keyname]
              @joyent_key = File.read(options[:joyent_keyfile])

              @rsa = OpenSSL::PKey::RSA.new(@joyent_key)

              @header_method = method(:header_for_signature)
            else
              raise ArgumentError, "options[:joyent_keyfile] provided does not exist."
            end
          elsif options[:joyent_password]
            @joyent_password = options[:joyent_password]

            @header_method = method(:header_for_basic)
          else
            raise ArgumentError, "Must provide either a joyent_password or joyent_keyname and joyent_keyfile pair"
          end

          @connection = Fog::Connection.new(
            @joyent_url,
            @persistent,
            @connection_options
          )
        end

        def request(request_options = {})
          (request_options[:headers] ||= {}).merge!({
            "X-Api-Version" => @joyent_version,
            "Content-Type" => "application/json",
            "Accept" => "application/json"
          }).merge!(@header_method.call)

          if request_options[:body]
            request_options[:body] = MultiJson.encode(request_options[:body])
          end

          response = @connection.request(request_options)

          if response.headers["Content-Type"] == "application/json"
            response.body = MultiJson.decode(response.body)
          end

          response
        end

        private

        def header_for_basic
          {
            "Authorization" => "Basic #{Base64.encode64("#{@joyent_username}:#{@joyent_password}").delete("\r\n")}"
          }
        end

        def header_for_signature
          date = Time.now.utc.httpdate
          signature = Base64.encode64(@rsa.sign("sha256", date)).delete("\r\n")
          key_id = "/#{@joyent_username}/keys/#{@joyent_keyname}"

          {
            "Date" => date,
            "Authorization" => "Signature keyId=\"#{key_id}\",algorithm=\"rsa-sha256\" #{signature}"
          }
        end

      end # Real
    end
  end
end
