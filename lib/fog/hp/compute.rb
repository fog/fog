require 'fog/hp/core'

module Fog
  module Compute
    class HP < Fog::Service
      requires    :hp_secret_key, :hp_tenant_id, :hp_avl_zone
      recognizes  :hp_auth_uri, :credentials, :hp_service_type
      recognizes  :hp_use_upass_auth_style, :hp_auth_version, :user_agent
      recognizes  :persistent, :connection_options
      recognizes  :hp_access_key, :hp_account_id  # :hp_account_id is deprecated use hp_access_key instead

      secrets     :hp_secret_key

      model_path 'fog/hp/models/compute'
      model       :address
      collection  :addresses
      model       :flavor
      collection  :flavors
      model       :image
      collection  :images
      model       :key_pair
      collection  :key_pairs
      model       :meta
      collection  :metadata
      model       :security_group
      collection  :security_groups
      model       :server
      collection  :servers

      request_path 'fog/hp/requests/compute'
      request :allocate_address
      request :associate_address
      request :attach_volume
      request :change_password_server
      #request :confirm_resized_server
      request :create_image
      request :create_key_pair
      request :create_security_group
      request :create_security_group_rule
      request :create_server
      request :create_persistent_server
      request :delete_image
      request :delete_key_pair
      request :delete_meta
      request :delete_security_group
      request :delete_security_group_rule
      request :delete_server
      request :detach_volume
      request :disassociate_address
      request :get_address
      request :get_console_output
      request :get_flavor_details
      request :get_image_details
      request :get_meta
      request :get_windows_password
      request :get_security_group
      request :get_server_details
      request :get_vnc_console
      request :list_addresses
      request :list_flavors
      request :list_flavors_detail
      request :list_images
      request :list_images_detail
      request :list_key_pairs
      request :list_metadata
      request :list_security_groups
      request :list_server_addresses
      request :list_server_private_addresses
      request :list_server_public_addresses
      request :list_server_volumes
      request :list_servers
      request :list_servers_detail
      request :reboot_server
      request :rebuild_server
      request :release_address
      #request :resize_server
      #request :revert_resized_server
      request :server_action
      request :set_metadata
      request :update_meta
      request :update_metadata
      request :update_server

      module Utils
        # extract windows password from log
        def extract_password_from_log(log_text)
          encrypted_text = ""
          section        = []
          return if log_text.nil?
          log_text.each_line do |line|
            case line
              when /^-----BEGIN (\w+)/
                section.push $1
                next
              when /^-----END (\w+)/
                section.pop
                next
            end

            case section
              when ["BASE64"]
                encrypted_text << line
            end
          end
          # return the encrypted portion only
          encrypted_text
        end

        def encrypt_using_public_key(text, public_key_data)
          return if (text.nil? || public_key_data.nil?)
          public_key = OpenSSL::PKey::RSA.new(public_key_data)
          encrypted_text = public_key.public_encrypt(text).strip
          Base64.encode64(encrypted_text)
        end

        def decrypt_using_private_key(encrypted_text, private_key_data)
          return if (encrypted_text.nil? || private_key_data.nil?)
          private_key = OpenSSL::PKey::RSA.new(private_key_data)
          from_base64 = Base64.decode64(encrypted_text)
          private_key.private_decrypt(from_base64).strip
        end
      end

      class Mock
        include Utils

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :last_modified => {
                :images  => {},
                :key_pairs => {},
                :security_groups => {},
                :servers => {},
                :addresses => {}
              },
              :images  => {},
              :key_pairs => {},
              :security_groups => {},
              :servers => {},
              :addresses => {}
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
          @hp_secret_key = options[:hp_secret_key]
          @connection_options = options[:connection_options] || {}
          ### Set an option to use the style of authentication desired; :v1 or :v2 (default)
          ### A symbol is required, we should ensure that the value is loaded as a symbol
          auth_version = options[:hp_auth_version] || :v2
          auth_version = auth_version.to_s.downcase.to_sym

          ### Pass the service name for compute via the options hash
          options[:hp_service_type] ||= "Compute"
          @hp_tenant_id = options[:hp_tenant_id]

          ### Make the authentication call
          if (auth_version == :v2)
            # Call the control services authentication
            credentials = Fog::HP.authenticate_v2(options, @connection_options)
            # the CS service catalog returns the cdn endpoint
            @hp_compute_uri = credentials[:endpoint_url]
            @credentials = credentials
          else
            # Call the legacy v1.0/v1.1 authentication
            credentials = Fog::HP.authenticate_v1(options, @connection_options)
            # the user sends in the cdn endpoint
            @hp_compute_uri = options[:hp_auth_uri]
          end

          @auth_token = credentials[:auth_token]

          uri = URI.parse(@hp_compute_uri)
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
              :path     => "#{@path}/#{params[:path]}"
            }), &block)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Compute::HP::NotFound.slurp(error)
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
