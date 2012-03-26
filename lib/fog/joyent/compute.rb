require File.expand_path(File.join(File.dirname(__FILE__), '..', 'joyent'))
require File.expand_path(File.join(File.dirname(__FILE__), 'errors'))
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

              @header_method = method(:header_for_signature_auth)
            else
              raise ArgumentError, "options[:joyent_keyfile] provided does not exist."
            end

          elsif options[:joyent_password]
            @joyent_password = options[:joyent_password]

            @header_method = method(:header_for_basic_auth)
          else
            raise ArgumentError, "Must provide either a joyent_password or joyent_keyname and joyent_keyfile pair"
          end

          @connection = Fog::Connection.new(
            @joyent_url,
            @persistent,
            @connection_options
          )
        end

        def request(request = {})
          request[:headers] = {
            "X-Api-Version" => @joyent_version,
            "Content-Type" => "application/json",
            "Accept" => "application/json"
          }.merge(request[:headers] || {}).merge(@header_method.call) 

          if request[:body]
            request[:body] = MultiJson.encode(request[:body])
          end

          response = @connection.request(request)

          if response.headers["Content-Type"] == "application/json"
            response.body = json_decode(response.body)
          end

          raise_if_error!(request, response)

          response
        end

        private

        def json_decode(body)
          parsed = MultiJson.decode(body)
          decode_time_attrs(parsed)
        end

        def header_for_basic_auth
          {
            "Authorization" => "Basic #{Base64.encode64("#{@joyent_username}:#{@joyent_password}").delete("\r\n")}"
          }
        end

        def header_for_signature_auth
          date = Time.now.utc.httpdate
          signature = Base64.encode64(@rsa.sign("sha256", date)).delete("\r\n")
          key_id = "/#{@joyent_username}/keys/#{@joyent_keyname}"

          {
            "Date" => date,
            "Authorization" => "Signature keyId=\"#{key_id}\",algorithm=\"rsa-sha256\" #{signature}"
          }
        end

        def decode_time_attrs(obj)
          if obj.kind_of?(Hash)
            obj["created"] = Time.parse(obj["created"]) if obj["created"]
            obj["updated"] = Time.parse(obj["updated"]) if obj["updated"]
          elsif obj.kind_of?(Array)
            obj.map do |o|
              decode_time_attrs(o)
            end
          end

          obj
        end

        def raise_if_error!(request, response)
          case response.status
          when 401 then
            raise Errors::Unauthorized.new('Invalid credentials were used', request, response)
          when 403 then
            raise Errors::Forbidden.new('No permissions to the specified resource', request, response)
          when 404 then
            raise Errors::NotFound.new('Requested resource was not found', request, response)
          when 405 then
            raise Errors::MethodNotAllowed.new('Method not supported for the given resource', request, response)
          when 406 then
            raise Errors::NotAcceptable.new('Try sending a different Accept header', request, response)
          when 409 then
            raise Errors::Conflict.new('Most likely invalid or missing parameters', request, response)
          when 414 then
            raise Errors::RequestEntityTooLarge.new('You sent too much data', request, response)
          when 415 then
            raise Errors::UnsupportedMediaType.new('You encoded your request in a format we don\'t understand', request, response)
          when 420 then
            raise Errors::PolicyNotForfilled.new('You are sending too many requests', request, response)
          when 449 then
            raise Errors::RetryWith.new('Invalid API Version requested; try with a different API Version', request, response)
          when 503 then
            raise Errors::ServiceUnavailable.new('Either there\'s no capacity in this datacenter, or we\'re in a maintenance window', request, response)
          end
        end

      end # Real
    end
  end
end
