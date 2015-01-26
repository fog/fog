require 'fog/joyent'
require 'fog/joyent/errors'
require 'thread'

module Fog
  module Joyent
    class Analytics < Fog::Service
      requires :joyent_username

      recognizes :joyent_password
      recognizes :joyent_url

      recognizes :joyent_keyname
      recognizes :joyent_keyfile
      recognizes :joyent_keydata
      recognizes :joyent_keyphrase
      recognizes :joyent_version
      request_path 'fog/joyent/requests/analytics'

      request :describe_analytics
      request :list_instrumentations
      request :get_instrumentation
      request :create_instrumentation
      request :delete_instrumentation
      request :get_instrumentation_value

      model_path 'fog/joyent/models/analytics'

      collection :joyent_modules
      model :joyent_module

      collection :metrics
      model :metric

      collection :fields
      model :field

      collection :types
      model :type

      collection :transformations
      model :transformation

      collection :instrumentations
      model :instrumentation

      model :value

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] =case key
                       when :instrumentation
                         { 'module' => "cpu",
                           'stat' => "usage",
                           'predicate' => {},
                           'decomposition' => ["zonename"],
                           'value-dimension' => 2,
                           'value-arity' => "discrete-decomposition",
                           'enabled' => true,
                           'retention-time' => 86400,
                           'idle-max' => 86400,
                           'transformations' => [],
                           'nsources' => 3,
                           'granularity' => 30,
                           'persist-data' => false,
                           'crtime' => 1388690982000,
                           'value-scope' => "point",
                           'id' => "63",
                           'uris' =>
                               [{ "uri" => "/#{@joyent_username}/analytics/instrumentations/63/value/raw",
                                  "name" => "value_raw" }] }
                       when :values
                         {
                             'value' => { 'zoneid' => 0 },
                             'transformations' => {},
                             'start_time' => Time.now.utc - 600,
                             'duration' => 30,
                             'end_time' => Time.now.utc - 570,
                             'nsources' => 1,
                             'minreporting' => 1,
                             'requested_start_time' => Time.now.utc - 600,
                             'requested_duration' => 30,
                             'requested_end_time' => Time.now.utc - 570
                         }
                       when :describe_analytics
                         {
                             'fields' => {
                                 'zonename' => {
                                     'label' => 'zone name',
                                     'type' => 'string'
                                 },
                                 'pid' => {
                                     'label' => 'process identifier',
                                     'type' => 'string'
                                 }
                             },
                             'modules' => {
                                 'cpu' => {
                                     'label' => 'CPU'
                                 }
                             },
                             'transformations' => {
                                 'geolocate' => {
                                     'label' => 'geolocate IP addresses',
                                     'fields' => ['raddr'] }
                             },
                             'metrics' => [{
                                               "module" => "cpu",
                                               "stat" => "thread_executions",
                                               "label" => "thread executions",
                                               "interval" => "interval",
                                               "fields" => ["hostname", "zonename", "runtime"],
                                               "unit" => "operations"
                                           }],
                             'types' => {
                                 'string' => {
                                     'arity' => "discrete",
                                     'unit' => ""
                                 }
                             }
                         }
                       else
                         {}
                       end
          end
        end

        def data
          self.class.data
        end

        def initialize(options = {})
          @joyent_username = options[:joyent_username]
          @joyent_password = options[:joyent_password]
          @joyent_url = 'https://us-sw-1.api.joyentcloud.com'
          @joyent_version = '~7'
        end

        def request(opts)
          raise "Not Implemented"
        end
      end # Mock

      class Real
        def initialize(options = {})
          @mutex = Mutex.new
          @connection_options = options[:connection_options] || {}
          @persistent = options[:persistent] || false

          @joyent_url = options[:joyent_url] || 'https://us-sw-1.api.joyentcloud.com'
          @joyent_version = options[:joyent_version] || '~7'
          @joyent_username = options[:joyent_username]

          unless @joyent_username
            raise ArgumentError, "options[:joyent_username] required"
          end

          if options[:joyent_keyname]
            @joyent_keyname = options[:joyent_keyname]
            @joyent_keyphrase = options[:joyent_keyphrase]
            @key_manager = Net::SSH::Authentication::KeyManager.new(nil, {
                :keys_only => true,
                :passphrase => @joyent_keyphrase
            })
            @header_method = method(:header_for_signature_auth)

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
          elsif options[:joyent_password]
            @joyent_password = options[:joyent_password]
            @header_method = method(:header_for_basic_auth)
          else
            raise ArgumentError, "Must provide either a joyent_password or joyent_keyname and joyent_keyfile pair"
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
          }.merge(opts[:headers] || {}).merge(@header_method.call)

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

        def header_for_basic_auth
          {
              "Authorization" => "Basic #{Base64.encode64("#{@joyent_username}:#{@joyent_password}").delete("\r\n")}"
          }
        end

        def header_for_signature_auth
          date = Time.now.utc.httpdate

          # Force KeyManager to load the key(s)
          @mutex.synchronize do
            @key_manager.each_identity {}
          end

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
          when 401 then
            raise Fog::Compute::Joyent::Errors::Unauthorized.new('Invalid credentials were used', request, response)
          when 403 then
            raise Fog::Compute::Joyent::Errors::Forbidden.new('No permissions to the specified resource', request, response)
          when 404 then
            raise Fog::Compute::Joyent::Errors::NotFound.new('Requested resource was not found', request, response)
          when 405 then
            raise Fog::Compute::Joyent::Errors::MethodNotAllowed.new('Method not supported for the given resource', request, response)
          when 406 then
            raise Fog::Compute::Joyent::Errors::NotAcceptable.new('Try sending a different Accept header', request, response)
          when 409 then
            raise Fog::Compute::Joyent::Errors::Conflict.new('Most likely invalid or missing parameters', request, response)
          when 414 then
            raise Fog::Compute::Joyent::Errors::RequestEntityTooLarge.new('You sent too much data', request, response)
          when 415 then
            raise Fog::Compute::Joyent::Errors::UnsupportedMediaType.new('You encoded your request in a format we don\'t understand', request, response)
          when 420 then
            raise Fog::Compute::Joyent::Errors::PolicyNotForfilled.new('You are sending too many requests', request, response)
          when 449 then
            raise Fog::Compute::Joyent::Errors::RetryWith.new('Invalid API Version requested; try with a different API Version', request, response)
          when 503 then
            raise Fog::Compute::Joyent::Errors::ServiceUnavailable.new('Either there\'s no capacity in this datacenter, or we\'re in a maintenance window', request, response)
          end
        end
      end # Real
    end
  end
end
