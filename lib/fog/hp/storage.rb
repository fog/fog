require 'fog/hp/core'

module Fog
  module Storage
    class HP < Fog::Service
      requires    :hp_secret_key, :hp_tenant_id, :hp_avl_zone
      recognizes  :hp_auth_uri, :hp_cdn_ssl, :hp_cdn_uri, :credentials, :hp_service_type
      recognizes  :persistent, :connection_options
      recognizes  :hp_use_upass_auth_style, :hp_auth_version, :user_agent
      recognizes  :hp_access_key, :hp_account_id  # :hp_account_id is deprecated use hp_access_key instead

      # :os_account_meta_temp_url_key is an OpenStack specific setting used to generate temporary urls.
      recognizes  :os_account_meta_temp_url_key

      secrets     :hp_secret_key, :os_account_meta_temp_url_key

      model_path 'fog/hp/models/storage'
      model       :directory
      collection  :directories
      model       :shared_directory
      collection  :shared_directories
      model       :file
      collection  :files
      model       :shared_file
      collection  :shared_files

      request_path 'fog/hp/requests/storage'
      request :delete_container
      request :delete_object
      request :delete_shared_object
      request :get_container
      request :get_containers
      request :get_object
      request :get_object_temp_url
      request :get_shared_container
      request :get_shared_object
      request :head_container
      request :head_containers
      request :head_object
      request :head_shared_container
      request :head_shared_object
      request :post_container
      request :post_object
      request :put_container
      request :put_object
      request :put_shared_object

      module Utils
        def cdn
          unless @hp_cdn_uri.nil?
            @cdn ||= Fog::CDN.new(
              :provider       => 'HP',
              :hp_access_key  => @hp_access_key,
              :hp_secret_key  => @hp_secret_key,
              :hp_auth_uri    => @hp_auth_uri,
              :hp_cdn_uri     => @hp_cdn_uri,
              :hp_tenant_id   => @hp_tenant_id,
              :hp_avl_zone    => @hp_avl_zone,
              :credentials    => @credentials,
              :connection_options => @connection_options
            )
            if @cdn.enabled?
              @cdn
            end
          else
            nil
          end
        end

        def url
          "#{@scheme}://#{@host}:#{@port}#{@path}"
        end

        def public_url(container=nil, object=nil)
          public_url = nil
          unless container.nil?
            if object.nil?
              # return container public url
              public_url = "#{url}/#{Fog::HP.escape(container)}"
            else
              # return object public url
              public_url = "#{url}/#{Fog::HP.escape(container)}/#{Fog::HP.escape(object)}"
            end
          end
          public_url
        end

        def perm_to_acl(perm, users=[])
          read_perm_acl = []
          write_perm_acl = []
          valid_public_perms  = ['pr', 'pw', 'prw']
          valid_account_perms = ['r', 'w', 'rw']
          valid_perms = valid_public_perms + valid_account_perms
          unless valid_perms.include?(perm)
            raise ArgumentError.new("permission must be one of [#{valid_perms.join(', ')}]")
          end
          # tackle the public access differently
          if valid_public_perms.include?(perm)
            case perm
              when "pr"
                read_perm_acl = [".r:*",".rlistings"]
              when "pw"
                write_perm_acl = ["*"]
              when "prw"
                read_perm_acl = [".r:*",".rlistings"]
                write_perm_acl = ["*"]
            end
          elsif valid_account_perms.include?(perm)
            # tackle the user access differently
            unless (users.nil? || users.empty?)
              # return the correct acls
              tenant_id = "*"  # this might change later
              acl_array = users.map { |u| "#{tenant_id}:#{u}" }
              #acl_string = acl_array.join(',')
              case perm
                when "r"
                  read_perm_acl = acl_array
                when "w"
                  write_perm_acl = acl_array
                when "rw"
                  read_perm_acl = acl_array
                  write_perm_acl = acl_array
              end
            end
          end
          return read_perm_acl, write_perm_acl
        end

        def perm_acl_to_header(read_perm_acl, write_perm_acl)
          header = {}
          if read_perm_acl.nil? && write_perm_acl.nil?
            header = {'X-Container-Read' => "", 'X-Container-Write' => ""}
          elsif !read_perm_acl.nil? && write_perm_acl.nil?
            header = {'X-Container-Read' => "#{read_perm_acl.join(',')}", 'X-Container-Write' => ""}
          elsif read_perm_acl.nil? && !write_perm_acl.nil?
            header = {'X-Container-Read' => "", 'X-Container-Write' => "#{write_perm_acl.join(',')}"}
          elsif !read_perm_acl.nil? && !write_perm_acl.nil?
            header = {'X-Container-Read' => "#{read_perm_acl.join(',')}", 'X-Container-Write' => "#{write_perm_acl.join(',')}"}
          end
          header
        end

        def header_to_perm_acl(read_header=nil, write_header=nil)
          read_h, write_h = nil
          read_h = read_header.split(',') unless read_header.nil?
          write_h = write_header.split(',') unless write_header.nil?
          return read_h, write_h
        end

        # Get an expiring object https url
        #
        # ==== Parameters
        # * container<~String> - Name of container containing object
        # * object<~String> - Name of object to get expiring url for
        # * expires<~Time> - An expiry time for this url
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String> - url for object
        def get_object_https_url(container, object, expires, options = {})
          create_temp_url(container, object, expires, "GET", {:port => 443}.merge(options).merge(:scheme => "https"))
        end

        # Get an expiring object http url
        #
        # ==== Parameters
        # * container<~String> - Name of container containing object
        # * object<~String> - Name of object to get expiring url for
        # * expires<~Time> - An expiry time for this url
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String> - url for object
        def get_object_http_url(container, object, expires, options = {})
          create_temp_url(container, object, expires, "GET", {:port => 80}.merge(options).merge(:scheme => "http"))
        end

        # Get an object http url expiring in the given amount of seconds
        #
        # ==== Parameters
        # * container<~String> - Name of container containing object
        # * object<~String> - Name of object to get expiring url for
        # * expires_secs<~Integer> - the amount of seconds from now until the url expires
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String> - url for object
        def generate_object_temp_url(container, object, expires_secs, method)
          expiration_time = (Time.now + expires_secs.to_i).to_i
          create_temp_url(container, object, expiration_time, method, {})
        end

        # creates a temporary url
        #
        # ==== Parameters
        # * container<~String> - Name of container containing object
        # * object<~String> - Name of object to get expiring url for
        # * expires<~Time> - An expiry time for this url
        # * method<~String> - The method to use for accessing the object (GET, PUT, HEAD)
        # * options<~Hash> - An optional options hash
        #   * 'scheme'<~String> - The scheme to use (http, https)
        #   * 'host'<~String> - The host to use
        #   * 'port'<~Integer> - The port to use
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String> - url for object
        def create_temp_url(container, object, expires, method, options = {})
          raise ArgumentError, "Insufficient parameters specified." unless (container && object && expires && method)

          # POST not allowed
          allowed_methods = %w{GET PUT HEAD}
          unless allowed_methods.include?(method)
            raise ArgumentError.new("Invalid method '#{method}' specified. Valid methods are: #{allowed_methods.join(', ')}")
          end

          expires        = expires.to_i
          scheme = options[:scheme] || @scheme
          host = options[:host] || @host
          port = options[:port] || @port

          # do not encode before signature generation, encode after
          sig_path = "#{@path}/#{container}/#{object}"
          encoded_path = "#{@path}/#{Fog::HP.escape(container)}/#{Fog::HP.escape(object)}"

          string_to_sign = "#{method}\n#{expires}\n#{sig_path}"

          signature = nil

          # HP uses a different strategy to create the signature that is passed to swift than OpenStack.
          # As the HP provider is broadly used by OpenStack users the OpenStack strategy is applied when
          # the @os_account_meta_temp_url_key is given.
          if @os_account_meta_temp_url_key
            hmac      = OpenSSL::HMAC.new(@os_account_meta_temp_url_key, OpenSSL::Digest::SHA1.new)
            signature= hmac.update(string_to_sign).hexdigest
          else
            #Note if the value of the @hp_secret_key is really a password, this will NOT work
            #HP Public Cloud FormPost and Temporary URL hashing algorithms require the secret key NOT password.
            if Fog::HP.instance_variable_get("@hp_use_upass_auth_style")
              raise ArgumentError, "Temporary URLS cannot be generated unless you login via access_key/secret_key"
            end
            # Only works with 1.9+ Not compatible with 1.8.7
            #signed_string = Digest::HMAC.hexdigest(string_to_sign, @hp_secret_key, Digest::SHA1)

            # Compatible with 1.8.7 onwards
            hmac = OpenSSL::HMAC.new(@hp_secret_key, OpenSSL::Digest::SHA1.new)
            signed_string = hmac.update(string_to_sign).hexdigest

            signature     = @hp_tenant_id.to_s + ":" + @hp_access_key.to_s + ":" + signed_string
            signature     = Fog::HP.escape(signature)
          end

          # generate the temp url using the signature and expiry
          temp_url_options = {
              :scheme => scheme,
              :host => host,
              :port => port,
              :path => encoded_path,
              :query => "temp_url_sig=#{signature}&temp_url_expires=#{expires}"
          }
          URI::Generic.build(temp_url_options).to_s
        end
      end

      class Mock
        include Utils
        def self.acls(type)
          type
        end

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :acls => {
                :container => {},
                :object => {}
              },
              :containers => {}
            }
            end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          # deprecate hp_account_id
          if options[:hp_account_id]
            Fog::Logger.deprecation(":hp_account_id is deprecated, please use :hp_access_key instead.")
            @hp_access_key = options.delete(:hp_account_id)
          end
          @hp_access_key = options[:hp_access_key]
          unless @hp_access_key
            raise ArgumentError.new("Missing required arguments: hp_access_key. :hp_account_id is deprecated, please use :hp_access_key instead.")
          end
          @hp_secret_key = options[:hp_secret_key]
          @hp_tenant_id = options[:hp_tenant_id]
          @os_account_meta_temp_url_key = options[:os_account_meta_temp_url_key]

          @hp_storage_uri = options[:hp_auth_uri]

          uri = URI.parse(@hp_storage_uri)
          @host   = uri.host
          @path   = uri.path
          @persistent = options[:persistent] || false
          @port   = uri.port
          @scheme = uri.scheme
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
        attr_reader :hp_cdn_ssl

        def initialize(options={})
          # deprecate hp_account_id
          if options[:hp_account_id]
            Fog::Logger.deprecation(":hp_account_id is deprecated, please use :hp_access_key instead.")
            options[:hp_access_key] = options.delete(:hp_account_id)
          end
          @hp_access_key = options[:hp_access_key]
          unless @hp_access_key
            raise ArgumentError.new("Missing required arguments: hp_access_key. :hp_account_id is deprecated, please use :hp_access_key instead.")
          end
          if options[:os_account_meta_temp_url_key]
            Fog::Logger.deprecation(":os_account_meta_temp_url_key is deprecated, and will be removed in a future release. please use the :openstack provider instead.")
            @os_account_meta_temp_url_key = options.delete(:os_account_meta_temp_url_key)
          end
          @hp_secret_key = options[:hp_secret_key]
          @hp_auth_uri   = options[:hp_auth_uri]
          @hp_cdn_ssl    = options[:hp_cdn_ssl]
          @connection_options = options[:connection_options] || {}
          ### Set an option to use the style of authentication desired; :v1 or :v2 (default)
          ### A symbol is required, we should ensure that the value is loaded as a symbol
          auth_version = options[:hp_auth_version] || :v2
          auth_version = auth_version.to_s.downcase.to_sym

          ### Pass the service name for object storage to the authentication call
          options[:hp_service_type] ||= "object-store"
          @hp_tenant_id = options[:hp_tenant_id]
          @hp_avl_zone  = options[:hp_avl_zone]

          ### Make the authentication call
          if (auth_version == :v2)
            # Call the control services authentication
            credentials = Fog::HP.authenticate_v2(options, @connection_options)
            # the CS service catalog returns the cdn endpoint
            @hp_storage_uri = credentials[:endpoint_url]
            @hp_cdn_uri  = credentials[:cdn_endpoint_url]
            @credentials = credentials
          else
            # Call the legacy v1.0/v1.1 authentication
            credentials = Fog::HP.authenticate_v1(options, @connection_options)
            # the user sends in the cdn endpoint
            @hp_storage_uri = options[:hp_auth_uri]
            @hp_cdn_uri  = options[:hp_cdn_uri]
          end

          @auth_token = credentials[:auth_token]

          uri = URI.parse(@hp_storage_uri)
          @host   = uri.host
          @path   = uri.path
          @persistent = options[:persistent] || false
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
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end

        # this request is used only for get_shared_container and get_shared_object calls
        def shared_request(params, parse_json = true, &block)
          begin
            response = @connection.request(params.merge!({
              :headers  => {
                'Content-Type' => 'application/json',
                'Accept'       => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :path     => "#{params[:path]}",
            }), &block)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Storage::HP::NotFound.slurp(error)
            when Excon::Errors::Forbidden
              Fog::HP::Errors::Forbidden.slurp(error)
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
