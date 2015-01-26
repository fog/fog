require 'fog/rackspace/core'

module Fog
  module Storage
    class Rackspace < Fog::Service
      include Fog::Rackspace::Errors

      class ServiceError < Fog::Rackspace::Errors::ServiceError; end
      class InternalServerError < Fog::Rackspace::Errors::InternalServerError; end
      class BadRequest < Fog::Rackspace::Errors::BadRequest; end

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url, :rackspace_servicenet, :rackspace_cdn_ssl, :persistent, :rackspace_region
      recognizes :rackspace_temp_url_key, :rackspace_storage_url, :rackspace_cdn_url

      model_path 'fog/rackspace/models/storage'
      model       :directory
      collection  :directories
      model       :file
      collection  :files
      model       :account

      request_path 'fog/rackspace/requests/storage'
      request :copy_object
      request :delete_container
      request :delete_object
      request :delete_static_large_object
      request :delete_multiple_objects
      request :get_container
      request :get_containers
      request :get_object
      request :get_object_https_url
      request :get_object_http_url
      request :head_container
      request :head_containers
      request :head_object
      request :put_container
      request :put_object
      request :put_object_manifest
      request :put_dynamic_obj_manifest
      request :put_static_obj_manifest
      request :post_set_meta_temp_url_key
      request :extract_archive

      module Common
        def apply_options(options)
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_cdn_ssl = options[:rackspace_cdn_ssl]
          @rackspace_auth_url = options[:rackspace_auth_url]
          @rackspace_servicenet = options[:rackspace_servicenet]
          @rackspace_auth_token = options[:rackspace_auth_token]
          @rackspace_storage_url = options[:rackspace_storage_url]
          @rackspace_cdn_url = options[:rackspace_cdn_url]
          @rackspace_region = options[:rackspace_region]
          @rackspace_temp_url_key = options[:rackspace_temp_url_key]
          @rackspace_must_reauthenticate = false
          @connection_options = options[:connection_options] || {}

          unless @rackspace_region || (@rackspace_storage_url && @rackspace_cdn_url)
            Fog::Logger.deprecation("Default region support will be removed in an upcoming release. Please switch to manually setting your endpoint. This requires settng the :rackspace_region option.")
          end

          @rackspace_region ||= :dfw
        end

        def cdn
          @cdn ||= Fog::CDN.new(
            :provider           => 'Rackspace',
            :rackspace_api_key  => @rackspace_api_key,
            :rackspace_auth_url => @rackspace_auth_url,
            :rackspace_cdn_url => @rackspace_cdn_url,
            :rackspace_username => @rackspace_username,
            :rackspace_region => @rackspace_region,
            :rackspace_cdn_ssl => @rackspace_cdn_ssl
          )
          if @cdn.enabled?
            @cdn
          end
        end

        def service_net?
          @rackspace_servicenet == true
        end

        def authenticate
          if @rackspace_must_reauthenticate || @rackspace_auth_token.nil?
            options = {
              :rackspace_api_key  => @rackspace_api_key,
              :rackspace_username => @rackspace_username,
              :rackspace_auth_url => @rackspace_auth_url,
              :connection_options => @connection_options
            }
            super(options)
          else
            @auth_token = @rackspace_auth_token
            @uri = URI.parse(@rackspace_storage_url)
          end
        end

        def service_name
          :cloudFiles
        end

        def request_id_header
          "X-Trans-Id"
        end

        def region
          @rackspace_region
        end

        def endpoint_uri(service_endpoint_url=nil)
          return @uri if @uri
          super(@rackspace_storage_url || service_endpoint_url, :rackspace_storage_url)
        end

        # Return Account Details
        # @return [Fog::Storage::Rackspace::Account] account details object
        def account
          account = Fog::Storage::Rackspace::Account.new(:service => self)
          account.reload
        end
      end

      class Mock < Fog::Rackspace::Service
        include Common

        # An in-memory container for use with Rackspace storage mocks. Includes
        # many `objects` mapped by (escaped) object name. Tracks container
        # metadata.
        class MockContainer
          attr_reader :objects, :meta, :service

          # Create a new container. Generally, you should call
          # {Fog::Rackspace::Storage#add_container} instead.
          def initialize(service)
            @service = service
            @objects, @meta = {}, {}
          end

          # Determine if this container contains any MockObjects or not.
          #
          # @return [Boolean]
          def empty?
            @objects.empty?
          end

          # Total sizes of all objects added to this container.
          #
          # @return [Integer] The number of bytes occupied by each contained
          #   object.
          def bytes_used
            @objects.values.map { |o| o.bytes_used }.reduce(0) { |a, b| a + b }
          end

          # Render the HTTP headers that would be associated with this
          # container.
          #
          # @return [Hash<String, String>] Any metadata supplied to this
          #   container, plus additional headers indicating the container's
          #   size.
          def to_headers
            @meta.merge({
              'X-Container-Object-Count' => @objects.size,
              'X-Container-Bytes-Used' => bytes_used
            })
          end

          # Access a MockObject within this container by (unescaped) name.
          #
          # @return [MockObject, nil] Return the MockObject at this name if
          #   one exists; otherwise, `nil`.
          def mock_object(name)
            @objects[Fog::Rackspace.escape(name)]
          end

          # Access a MockObject with a specific name, raising a
          # `Fog::Storage::Rackspace::NotFound` exception if none are present.
          #
          # @param name [String] (Unescaped) object name.
          # @return [MockObject] The object within this container with the
          #   specified name.
          def mock_object!(name)
            mock_object(name) or raise Fog::Storage::Rackspace::NotFound.new
          end

          # Add a new MockObject to this container. An existing object with
          # the same name will be overwritten.
          #
          # @param name [String] The object's name, unescaped.
          # @param data [String, #read] The contents of the object.
          def add_object(name, data)
            @objects[Fog::Rackspace.escape(name)] = MockObject.new(data, service)
          end

          # Remove a MockObject from the container by name. No effect if the
          # object is not present beforehand.
          #
          # @param name [String] The (unescaped) object name to remove.
          def remove_object(name)
            @objects.delete Fog::Rackspace.escape(name)
          end
        end

        # An in-memory Swift object.
        class MockObject
          attr_reader :hash, :bytes_used, :content_type, :last_modified
          attr_reader :body, :meta, :service
          attr_accessor :static_manifest

          # Construct a new object. Generally, you should call
          # {MockContainer#add_object} instead of instantiating these directly.
          def initialize(data, service)
            data = Fog::Storage.parse_data(data)
            @service = service

            @bytes_used = data[:headers]['Content-Length']
            @content_type = data[:headers]['Content-Type']
            if data[:body].respond_to? :read
              @body = data[:body].read
            else
              @body = data[:body]
            end
            @last_modified = Time.now.utc
            @hash = Digest::MD5.hexdigest(@body)
            @meta = {}
            @static_manifest = false
          end

          # Determine if this object was created as a static large object
          # manifest.
          #
          # @return [Boolean]
          def static_manifest?
            @static_manifest
          end

          # Determine if this object has the metadata header that marks it as a
          # dynamic large object manifest.
          #
          # @return [Boolean]
          def dynamic_manifest?
            ! large_object_prefix.nil?
          end

          # Iterate through each MockObject that contains a part of the data for
          # this logical object. In the normal case, this will only yield the
          # receiver directly. For dynamic and static large object manifests,
          # however, this call will yield each MockObject that contains a part
          # of the whole, in sequence.
          #
          # Manifests that refer to containers or objects that don't exist will
          # skip those sections and log a warning, instead.
          #
          # @yield [MockObject] Each object that holds a part of this logical
          #   object.
          def each_part
            case
            when dynamic_manifest?
              # Concatenate the contents and sizes of each matching object.
              # Note that cname and oprefix are already escaped.
              cname, oprefix = large_object_prefix.split('/', 2)

              target_container = service.data[cname]
              if target_container
                all = target_container.objects.keys
                matching = all.select { |name| name.start_with? oprefix }
                keys = matching.sort

                keys.each do |name|
                  yield target_container.objects[name]
                end
              else
                Fog::Logger.warning "Invalid container in dynamic object manifest: #{cname}"
                yield self
              end
            when static_manifest?
              Fog::JSON.decode(body).each do |segment|
                cname, oname = segment['path'].split('/', 2)

                cont = service.mock_container cname
                unless cont
                  Fog::Logger.warning "Invalid container in static object manifest: #{cname}"
                  next
                end

                obj = cont.mock_object oname
                unless obj
                  Fog::Logger.warning "Invalid object in static object manifest: #{oname}"
                  next
                end

                yield obj
              end
            else
              yield self
            end
          end

          # Access the object name prefix that controls which other objects
          # comprise a dynamic large object.
          #
          # @return [String, nil] The object name prefix, or `nil` if none is
          #   present.
          def large_object_prefix
            @meta['X-Object-Manifest']
          end

          # Construct the fake HTTP headers that should be returned on requests
          # targetting this object. Includes computed `Content-Type`,
          # `Content-Length`, `Last-Modified` and `ETag` headers in addition to
          # whatever metadata has been associated with this object manually.
          #
          # @return [Hash<String, String>] Header values stored in a Hash.
          def to_headers
            {
              'Content-Type' => @content_type,
              'Content-Length' => @bytes_used,
              'Last-Modified' => @last_modified.strftime('%a, %b %d %Y %H:%M:%S %Z'),
              'ETag' => @hash
            }.merge(@meta)
          end
        end

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        # Access or create account-wide metadata.
        #
        # @return [Hash<String,String>] A metadata hash pre-populated with
        #   a (fake) temp URL key.
        def self.account_meta
          @account_meta ||= Hash.new do |hash, key|
            hash[key] = {
              'X-Account-Meta-Temp-Url-Key' => Fog::Mock.random_hex(32)
            }
          end
        end

        def self.reset
          @data = nil
          @account_meta = nil
        end

        def initialize(options={})
          apply_options(options)
          authenticate
          endpoint_uri
        end

        def data
          self.class.data[@rackspace_username]
        end

        def account_meta
          self.class.account_meta[@rackspace_username]
        end

        def reset_data
          self.class.data.delete(@rackspace_username)
        end

        # Access a MockContainer with the specified name, if one exists.
        #
        # @param cname [String] The (unescaped) container name.
        # @return [MockContainer, nil] The named MockContainer, or `nil` if
        #   none exist.
        def mock_container(cname)
          data[Fog::Rackspace.escape(cname)]
        end

        # Access a MockContainer with the specified name, raising a
        # {Fog::Storage::Rackspace::NotFound} exception if none exist.
        #
        # @param cname [String] The (unescaped) container name.
        # @throws [Fog::Storage::Rackspace::NotFound] If no container with the
        #   given name exists.
        # @return [MockContainer] The existing MockContainer.
        def mock_container!(cname)
          mock_container(cname) or raise Fog::Storage::Rackspace::NotFound.new
        end

        # Create and add a new, empty MockContainer with the given name. An
        # existing container with the same name will be replaced.
        #
        # @param cname [String] The (unescaped) container name.
        # @return [MockContainer] The container that was added.
        def add_container(cname)
          data[Fog::Rackspace.escape(cname)] = MockContainer.new(self)
        end

        # Remove a MockContainer with the specified name. No-op if the
        # container does not exist.
        #
        # @param cname [String] The (unescaped) container name.
        def remove_container(cname)
          data.delete Fog::Rackspace.escape(cname)
        end

        def ssl?
          !!@rackspace_cdn_ssl
        end

        private

        def authenticate_v1(options)
          uuid = Fog::Rackspace::MockData.uuid
          endpoint_uri "https://storage101.#{region}1.clouddrive.com/v1/MockCloudFS_#{uuid}"
          @auth_token = Fog::Mock.random_hex(32)
        end
      end

      class Real < Fog::Rackspace::Service
        include Common

        attr_reader :rackspace_cdn_ssl

        def initialize(options={})
          apply_options(options)

          authenticate
          @persistent = options[:persistent] || false
          Excon.defaults[:ssl_verify_peer] = false if service_net?
          @connection = Fog::Core::Connection.new(endpoint_uri.to_s, @persistent, @connection_options)
        end

        # Using SSL?
        # @return [Boolean] return true if service is returning SSL-Secured URLs in public_url methods
        # @see Directory#public_url
        def ssl?
          !!rackspace_cdn_ssl
        end

        # Resets presistent service connections
        def reload
          @connection.reset
        end

        def request(params, parse_json = true)
          super
        rescue Excon::Errors::NotFound => error
          raise NotFound.slurp(error, self)
        rescue Excon::Errors::BadRequest => error
          raise BadRequest.slurp(error, self)
        rescue Excon::Errors::InternalServerError => error
          raise InternalServerError.slurp(error, self)
        rescue Excon::Errors::HTTPStatusError => error
          raise ServiceError.slurp(error, self)
        end

        private

        def authenticate_v1(options)
          credentials = Fog::Rackspace.authenticate(options, @connection_options)
          endpoint_uri credentials['X-Storage-Url']
          @auth_token = credentials['X-Auth-Token']
        end
      end
    end
  end
end
