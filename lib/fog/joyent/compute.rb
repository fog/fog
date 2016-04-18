require 'fog/joyent/core'
require 'fog/joyent/errors'

module Fog
  module Compute
    class Joyent < Fog::Service
      requires :joyent_username

      recognizes :joyent_url

      recognizes :joyent_keyname
      recognizes :joyent_keyfile
      recognizes :joyent_keydata
      recognizes :joyent_keyphrase
      recognizes :joyent_version

      secrets :joyent_keydata, :joyent_keyphrase

      model_path 'fog/joyent/models/compute'
      request_path 'fog/joyent/requests/compute'

      request :list_datacenters
      # request :get_datacenter

      # Datacenters
      collection :datacenters
      model :datacenter

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
      request :list_images
      request :get_image

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

      # Networks
      collection :networks
      model :network
      request :list_networks

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
          @joyent_username = options[:joyent_username]
        end

        def request(opts)
          raise "Not Implemented"
        end
      end # Mock

      class Real
        attr_accessor :joyent_version
        attr_accessor :joyent_url

        def initialize(options = {})
          @connection_options = options[:connection_options] || {}
          @persistent = options[:persistent] || false

          @joyent_url = options[:joyent_url] || 'https://us-sw-1.api.joyentcloud.com'
          @joyent_version = options[:joyent_version] || '~7'
          @joyent_username = options[:joyent_username]

          unless @joyent_username
            raise ArgumentError, "options[:joyent_username] required"
          end

          if options[:joyent_keyname]
            begin
              require "net/ssh"
            rescue LoadError
              Fog::Logger.warning("'net/ssh' missing, please install and try again.")
              exit(1)
            end
            @joyent_keyname = options[:joyent_keyname]
            @joyent_keyphrase = options[:joyent_keyphrase]
            @key_manager = Net::SSH::Authentication::KeyManager.new(nil, {
                :keys_only => true,
                :passphrase => @joyent_keyphrase
            })

            if options[:joyent_keyfile]
              if File.exist?(options[:joyent_keyfile])
                @joyent_keyfile = options[:joyent_keyfile]
                @key_manager.add(@joyent_keyfile)
              else
                raise ArgumentError, "options[:joyent_keyfile] provided does not exist."
              end
            elsif options[:joyent_keydata]
              if options[:joyent_keydata].to_s.empty?
                raise ArgumentError, 'options[:joyent_keydata] must not be blank'
              else
                @joyent_keydata = options[:joyent_keydata]
                @key_manager.add_key_data(@joyent_keydata)
              end
            end
          else
            raise ArgumentError, "Must provide a joyent_keyname and joyent_keyfile pair"
          end

          @connection = Fog::XML::Connection.new(
            @joyent_url,
            @persistent,
            @connection_options
          )
        end

        def request(opts = {})
          opts[:headers] = {
            "X-Api-Version" => @joyent_version,
            "Content-Type" => "application/json",
            "Accept" => "application/json"
          }.merge(opts[:headers] || {}).merge(header_for_signature_auth)

          if opts[:body]
            opts[:body] = Fog::JSON.encode(opts[:body])
          end

          response = @connection.request(opts)
          if response.headers["Content-Type"] == "application/json"
            response.body = json_decode(response.body)
          end

          response
        rescue Excon::Errors::HTTPStatusError => e
          if e.response.headers["Content-Type"] == "application/json"
            e.response.body = json_decode(e.response.body)
          end
          raise_if_error!(e.request, e.response)
        end

        private

        def json_decode(body)
          parsed = Fog::JSON.decode(body)
          decode_time_attrs(parsed)
        end

        def header_for_signature_auth
          date = Time.now.utc.httpdate

          # Force KeyManager to load the key(s)
          @key_manager.each_identity {}

          key = @key_manager.known_identities.keys.first

          sig = if key.kind_of? OpenSSL::PKey::RSA
            @key_manager.sign(key, date)[15..-1]
          else
            key = OpenSSL::PKey::DSA.new(File.read(@joyent_keyfile), @joyent_keyphrase)
            key.sign('sha1', date)
          end

          key_id = "/#{@joyent_username}/keys/#{@joyent_keyname}"
          key_type = key.class.to_s.split('::').last.downcase.to_sym

          unless [:rsa, :dsa].include? key_type
            raise Joyent::Errors::Unauthorized.new('Invalid key type -- only rsa or dsa key is supported')
          end

          signature = Base64.encode64(sig).delete("\r\n")

          {
            "Date" => date,
            "Authorization" => "Signature keyId=\"#{key_id}\",algorithm=\"#{key_type}-sha1\" #{signature}"
          }
        rescue Net::SSH::Authentication::KeyManagerError => e
          raise Joyent::Errors::Unauthorized.new('SSH Signing Error: :#{e.message}', e)
        end

        def decode_time_attrs(obj)
          if obj.kind_of?(Hash)
            obj["created"] = Time.parse(obj["created"]) unless obj["created"].nil? or obj["created"] == ''
            obj["updated"] = Time.parse(obj["updated"]) unless obj["updated"].nil? or obj["updated"] == ''
          elsif obj.kind_of?(Array)
            obj.map do |o|
              decode_time_attrs(o)
            end
          end

          obj
        end

        def raise_if_error!(request, response)
          case response.status
          when 400 then
            raise Joyent::Errors::BadRequest.new('Bad Request', request, response)
          when 401 then
            raise Joyent::Errors::Unauthorized.new('Invalid credentials were used', request, response)
          when 403 then
            raise Joyent::Errors::Forbidden.new('No permissions to the specified resource', request, response)
          when 404 then
            raise Joyent::Errors::NotFound.new('Requested resource was not found', request, response)
          when 405 then
            raise Joyent::Errors::MethodNotAllowed.new('Method not supported for the given resource', request, response)
          when 406 then
            raise Joyent::Errors::NotAcceptable.new('Try sending a different Accept header', request, response)
          when 409 then
            raise Joyent::Errors::Conflict.new('Most likely invalid or missing parameters', request, response)
          when 414 then
            raise Joyent::Errors::RequestEntityTooLarge.new('You sent too much data', request, response)
          when 415 then
            raise Joyent::Errors::UnsupportedMediaType.new('You encoded your request in a format we don\'t understand', request, response)
          when 420 then
            raise Joyent::Errors::PolicyNotForfilled.new('You are sending too many requests', request, response)
          when 449 then
            raise Joyent::Errors::RetryWith.new('Invalid API Version requested; try with a different API Version', request, response)
          when 503 then
            raise Joyent::Errors::ServiceUnavailable.new('Either there\'s no capacity in this datacenter, or we\'re in a maintenance window', request, response)
          end
        end
      end # Real
    end
  end
end
