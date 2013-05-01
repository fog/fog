require 'fog/hp'
require 'fog/storage'

module Fog
  module Storage
    class HP < Fog::Service

      requires    :hp_secret_key, :hp_tenant_id, :hp_avl_zone
      recognizes  :hp_auth_uri, :hp_cdn_ssl, :hp_cdn_uri
      recognizes  :persistent, :connection_options
      recognizes  :hp_use_upass_auth_style, :hp_auth_version, :user_agent
      recognizes  :hp_access_key, :hp_account_id  # :hp_account_id is deprecated use hp_access_key instead

      secrets     :hp_secret_key

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

        def generate_object_temp_url(container, object, expires_secs, method)
          return unless (container && object && expires_secs && method)

          # POST not allowed
          allowed_methods = %w{GET PUT HEAD}
          unless allowed_methods.include?(method)
            raise ArgumentError.new("Invalid method '#{method}' specified. Valid methods are: #{allowed_methods.join(', ')}")
          end

          expires = (Time.now + expires_secs.to_i).to_i

          # split up the storage uri
          uri = URI.parse(@hp_storage_uri)
          host   = uri.host
          path   = uri.path
          port   = uri.port
          scheme = uri.scheme

          # do not encode before signature generation, encode after
          sig_path = "#{path}/#{container}/#{object}"
          encoded_path = "#{path}/#{Fog::HP.escape(container)}/#{Fog::HP.escape(object)}"

          string_to_sign = "#{method}\n#{expires}\n#{sig_path}"
          # Only works with 1.9+ Not compatible with 1.8.7
          #signed_string = Digest::HMAC.hexdigest(string_to_sign, @hp_secret_key, Digest::SHA1)
          # Compatible with 1.8.7 onwards
          hmac = OpenSSL::HMAC.new(@hp_secret_key, OpenSSL::Digest::SHA1.new)
          signed_string = hmac.update(string_to_sign).hexdigest

          signature = @hp_tenant_id.to_s + ":" + @hp_access_key.to_s + ":" + signed_string
          signature = Fog::HP.escape(signature)

          # generate the temp url using the signature and expiry
          "#{scheme}://#{host}:#{port}#{encoded_path}?temp_url_sig=#{signature}&temp_url_expires=#{expires}"
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
          require 'mime/types'
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
        attr_reader :hp_cdn_ssl

        def initialize(options={})
          require 'mime/types'
          # deprecate hp_account_id
          if options[:hp_account_id]
            Fog::Logger.deprecation(":hp_account_id is deprecated, please use :hp_access_key instead.")
            options[:hp_access_key] = options.delete(:hp_account_id)
          end
          @hp_access_key = options[:hp_access_key]
          unless @hp_access_key
            raise ArgumentError.new("Missing required arguments: hp_access_key. :hp_account_id is deprecated, please use :hp_access_key instead.")
          end
          @hp_secret_key = options[:hp_secret_key]
          @hp_auth_uri   = options[:hp_auth_uri]
          @hp_cdn_ssl    = options[:hp_cdn_ssl]
          @connection_options = options[:connection_options] || {}
          ### Set an option to use the style of authentication desired; :v1 or :v2 (default)
          auth_version = options[:hp_auth_version] || :v2
          ### Pass the service name for object storage to the authentication call
          options[:hp_service_type] = "Object Storage"
          @hp_tenant_id = options[:hp_tenant_id]
          @hp_avl_zone  = options[:hp_avl_zone]

          ### Make the authentication call
          if (auth_version == :v2)
            # Call the control services authentication
            credentials = Fog::HP.authenticate_v2(options, @connection_options)
            # the CS service catalog returns the cdn endpoint
            @hp_storage_uri = credentials[:endpoint_url]
            @hp_cdn_uri  = credentials[:cdn_endpoint_url]
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

          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
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
              :host     => @host,
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
