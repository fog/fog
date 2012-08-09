require 'fog/ecloud/collection'
module Fog
  module Ecloud
    class Model < Fog::Model

      attr_accessor :loaded
      alias_method :loaded?, :loaded

      def reload
        instance = super
        @loaded = true
        instance
      end

      def load_unless_loaded!
        unless @loaded
          reload
        end
      end

    end
  end
end
module Fog
  module Compute


    class Ecloud < Fog::Service

      API_URL = "https://services.enterprisecloud.terremark.com"
      attr_reader :authentication_method, :version

      #### Credentials
      #requires 
      recognizes :ecloud_username, :ecloud_password, :ecloud_version, :ecloud_access_key, :ecloud_private_key, :ecloud_authentication_method

      #### Models
      model_path 'fog/ecloud/models/compute'
      model :organization
      collection :organizations
        model :location
        collection :locations
          model :catalog_item
          collection :catalog
            model :catalog_configuration
            collection :catalog_configurations
        model :environment
        collection :environments
          model :task
          collection :tasks
          model :compute_pool
          collection :compute_pools
            model :server
            collection :servers
              model :hardware_configuration
              collection :hardware_configurations
              model :server_configuration_option
              collection :server_configuration_options
              model :guest_process
              collection :guest_processes
            model :layout
            collection :layouts
              model :row
              collection :rows
                model :group
                collection :groups
            model :internet_service
            collection :internet_services
              model :node
              collection :nodes
              model :monitor
              collection :monitors
            model :cpu_usage_detail
            collection :cpu_usage_detail_summary
            model :memory_usage_detail
            collection :memory_usage_detail_summary
            model :storage_usage_detail
            collection :storage_usage_detail_summary
            model :operating_system_family
            collection :operating_system_families
              model :operating_system
              collection :operating_systems
            model :template
            collection :templates
          model :firewall_acl
          collection :firewall_acls
          model :network
          collection :networks
            model :ip_address
            collection :ip_addresses
          model :physical_device
          collection :physical_devices
          model :public_ip
          collection :public_ips
          model :trusted_network_group
          collection :trusted_network_groups
          model :backup_internet_service
          collection :backup_internet_services
          model :rnat
          collection :rnats
            model :association
            collection :associations
        model :tag
        collection :tags
        model :admin_organization
        collection :admin_organizations
          model :ssh_key
          collection :ssh_keys
          model :password_complexity_rule
          collection :password_complexity_rules
          model :authentication_level
          collection :authentication_levels
          model :login_banner
          collection :login_banners
        model :user
        collection :users
          model :role
          collection :roles
          model :ssh_key
          collection :ssh_keys
        model :support_ticket
        collection :support_tickets

      #### Requests
      request_path 'fog/ecloud/requests/compute'
      request :get_organization
      request :get_organizations
      request :get_location
      request :get_locations
      request :get_environment
      request :get_task
      request :get_tasks
      request :get_compute_pool
      request :get_compute_pools
      request :get_server
      request :get_servers
      request :get_network
      request :get_networks
      request :get_physical_device
      request :get_physical_devices
      request :get_layout
      request :get_layouts
      request :get_row
      request :get_rows
      request :get_group
      request :get_groups
      request :get_public_ip
      request :get_public_ips
      request :get_network_summary
      request :get_internet_service
      request :get_internet_services
      request :get_node
      request :get_nodes
      request :get_firewall_acl
      request :get_firewall_acls
      request :get_trusted_network_group
      request :get_trusted_network_groups
      request :get_catalog
      request :get_catalog_item
      request :get_tag
      request :get_tags
      request :get_hardware_configuration
      request :get_hardware_configurations
      request :get_server_configuration_option
      request :get_server_configuration_options
      request :get_guest_process
      request :get_guest_processes
      request :get_cpu_usage_detail
      request :get_cpu_usage_detail_summary
      request :get_memory_usage_detail
      request :get_memory_usage_detail_summary
      request :get_storage_usage_detail
      request :get_storage_usage_detail_summary
      request :get_operating_system_family
      request :get_operating_system_families
      request :get_operating_system
      request :get_template
      request :get_templates
      request :get_monitor
      request :get_monitors
      request :get_backup_internet_service
      request :get_backup_internet_services
      request :get_rnat
      request :get_rnats
      request :get_association
      request :get_associations
      request :get_admin_organization
      request :get_admin_organizations
      request :get_ssh_key
      request :get_ssh_keys
      request :get_password_complexity_rule
      request :get_password_complexity_rules
      request :get_authentication_level
      request :get_authentication_levels
      request :get_login_banner
      request :get_login_banners
      request :get_user
      request :get_users
      request :get_role
      request :get_roles
      request :get_api_key
      request :get_api_keys
      request :get_support_ticket
      request :get_support_tickets
      request :get_ip_address
      request :get_ip_addresses
      request :get_catalog_configuration
      request :get_catalog_configurations
      request :compute_pool_edit
      request :virtual_machine_create_from_template
      request :virtual_machine_import
      request :virtual_machine_copy
      request :virtual_machine_copy_identical
      request :virtual_machine_edit
      request :virtual_machine_add_ip
      request :virtual_machine_edit_hardware_configuration
      request :virtual_machine_delete
      request :virtual_machine_upload_file
      request :internet_service_create
      request :internet_service_edit
      request :internet_service_delete
      request :backup_internet_service_create
      request :backup_internet_service_edit
      request :backup_internet_service_delete
      request :node_service_create
      request :node_service_delete
      request :node_service_edit
      request :monitors_create_default
      request :monitors_create_ping
      request :monitors_create_http
      request :monitors_create_ecv
      request :monitors_create_loopback
      request :monitors_edit_ping
      request :monitors_edit_http
      request :monitors_edit_ecv
      request :monitors_enable
      request :monitors_disable
      request :rnat_associations_edit_network
      request :rnat_associations_create_device
      request :rnat_associations_delete
      request :rows_create
      request :rows_edit
      request :rows_moveup
      request :rows_movedown
      request :rows_delete
      request :groups_create
      request :groups_edit
      request :groups_moveup
      request :groups_movedown
      request :groups_delete
      request :trusted_network_groups_create
      request :trusted_network_groups_edit
      request :trusted_network_groups_delete
      request :firewall_acls_create
      request :firewall_acls_delete
      request :public_ip_activate
      request :power_on
      request :power_off
      request :power_reset
      request :power_shutdown

      module Shared

        attr_reader :versions_uri

        def default_organization_uri
          @default_organization_uri ||= begin
            unless @login_results
              do_login
            end
            case @login_results.body[:Org]
            when Array
              @login_results.body[:Org].first[:href]
            when Hash
              @login_results.body[:Org][:href]
            else
              nil
            end
          end
        end

        # login handles the auth, but we just need the Set-Cookie
        # header from that call.
        def do_login
          @login_results = get_organizations
        end

        def ecloud_xmlns
          {
            "xmlns"     => "urn:tmrk:eCloudExtensions-2.8",
            "xmlns:i"   => "http://www.w3.org/2001/XMLSchema-instance"
          }
        end

        def ensure_unparsed(uri)
          if uri.is_a?(String)
            uri
          else
            uri.to_s
          end
        end

        def supported_versions
          @supported_versions ||= get_versions(@versions_uri).body[:VersionInfo]
        end

        def xmlns
          { "xmlns" => "http://www.vmware.com/vcloud/v0.8",
            "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
            "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema" }
        end

        def validate_data(required_opts = [], options = {})
          unless required_opts.all? { |opt| options.has_key?(opt) }
            raise ArgumentError.new("Required data missing: #{(required_opts - options.keys).map(&:inspect).join(", ")}")
          end
        end

      end

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
          @ecloud_api_key = options[:ecloud]
        end

        def data
          self.class.data[@ecloud_api_key]
        end

        def reset_data
          self.class.data.delete(@ecloud_api_key)
        end
      end


      class Real
        include Shared

        class << self
          def basic_request(*args)
            self.class_eval <<-EOS, __FILE__,__LINE__
              def #{args[0]}(uri)
                request({
                :expects => #{args[1] || 200},
                :method => '#{args[2] || 'GET'}',
                :headers => #{args[3] ? args[3].inspect : '{}'},
                :body => '#{args[4] ? args[4] : ''}',
                :parse => true,
                :uri => uri })
              end
            EOS
          end

          def unauthenticated_basic_request(*args)
            self.class_eval <<-EOS, __FILE__,__LINE__
              def #{args[0]}(uri)
                unauthenticated_request({
                :expects => #{args[1] || 200},
                :method => '#{args[2] || 'GET'}',
                :headers => #{args[3] ? args[3].inspect : '{}'},
                :parse => true,
                :uri => uri })
              end
            EOS
          end
        end


        def initialize(options = {})
          require 'builder'
          require 'fog/core/parser'
          @connections             = {}
          @connection_options      = options[:connection_options] || {}
          @host                    = options[:ecloud_host] || API_URL
          @persistent              = options[:persistent] || false
          @version                 = options[:ecloud_version] || "2012-03-01"
          @authentication_method   = options[:ecloud_authentication_method] || :cloud_api_auth
          @access_key              = options[:ecloud_access_key]
          @private_key             = options[:ecloud_private_key]
          if @private_key.nil? || @authentication_method == :basic_auth
            @authentication_method = :basic_auth
            @username              = options[:ecloud_username]
            @password              = options[:ecloud_password]
            if @username.nil? || @password.nil?
              raise RuntimeError, "No credentials (cloud auth, or basic auth) passed!"
            end
          else
            @hmac                  = Fog::HMAC.new("sha256", @private_key)
          end
        end

        def default_organization_uri
          "/cloudapi/ecloud/organizations/"
        end

        def request(params)
          begin
            do_request(params)
          rescue Excon::Errors::Unauthorized => e
            raise RuntimeError, "Invalid authentication data: #{e}"
          end
        end

        def do_request(params)
          # Convert the uri to a URI if it's a string.
          if params[:uri].is_a?(String)
            params[:uri] = URI.parse(@host + params[:uri])
          end
          host_url = "#{params[:uri].scheme}://#{params[:uri].host}#{params[:uri].port ? ":#{params[:uri].port}" : ''}"

          # Hash connections on the host_url ... There's nothing to say we won't get URI's that go to
          # different hosts.
          @connections[host_url] ||= Fog::Connection.new(host_url, @persistent, @connection_options)

          # Set headers to an empty hash if none are set.
          headers = set_extra_headers_for(params) || set_extra_headers_for({})

          # Make the request
          options = {:expects => params[:expects] || 200, :method => params[:method] || 'GET', :path => params[:uri].path + "#{"?#{params[:uri].query}" if params[:uri].query}", :headers => headers}
          unless params[:body].empty?
            options.merge!({:body => params[:body]})
          end
          #puts options[:body].inspect
          response = @connections[host_url].request(options)

          # Parse the response body into a hash
          unless response.body.empty?
            if params[:parse]
              document = Fog::ToHashDocument.new
              parser = Nokogiri::XML::SAX::PushParser.new(document)
              parser << response.body
              parser.finish

              response.body = document.body
            end
          end
          response
        end

        private

        # if Authorization and x-tmrk-authorization are used, the x-tmrk-authorization takes precendence.
        def set_extra_headers_for(params)
         maor_headers = {
           'x-tmrk-version' => @version,
           'Date' => Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S GMT"),
         }
         params[:headers].merge!(maor_headers)
         if params[:method]=="POST" || params[:method]=="PUT"
           params[:headers].merge!({"Content-Type" => 'application/xml'}) unless params[:headers]['Content-Type']
           params[:headers].merge!({"Accept" => 'application/xml'})
         end
         unless params[:body].empty?
            params[:headers].merge!({"x-tmrk-contenthash" => "Sha256 #{Base64.encode64(Digest::SHA2.digest(params[:body].to_s)).chomp}"})
         end
         if @authentication_method == :basic_auth
           params[:headers].merge!({'Authorization' => "Basic #{Base64.encode64(@username+":"+@password).delete("\r\n")}"})
         elsif @authentication_method == :cloud_api_auth
           signature = cloud_api_signature(params)
           params[:headers].merge!({
             "x-tmrk-authorization" => %{CloudApi AccessKey="#{@access_key}" SignatureType="HmacSha256" Signature="#{signature}"}
           })
         end
         params[:headers]
        end

        def cloud_api_signature(params)
          verb = params[:method].upcase
          headers = params[:headers]
          path = params[:uri].path
          canonicalized_headers = canonicalize_headers(headers)
          canonicalized_resource = canonicalize_resource(path)
          string = [ verb,
                     headers['Content-Length'].to_s,
                     headers['Content-Type'].to_s,
                     headers['Date'].to_s,
                     canonicalized_headers,
                     canonicalized_resource + "\n"
                   ].join("\n")
          Base64.encode64(@hmac.sign(string)).chomp
        end


        # section 5.6.3.2 in the ~1000 page pdf spec
        def canonicalize_headers(headers)
          tmp = headers.inject({}) {|ret, h| ret[h.first.downcase] = h.last if h.first.match(/^x-tmrk/i) ; ret }
          tmp.reject! {|k,v| k == "x-tmrk-authorization" }
          tmp = tmp.sort.map{|e| "#{e.first}:#{e.last}" }.join("\n")
          tmp
        end

        # section 5.6.3.3 in the ~1000 page pdf spec
        def canonicalize_resource(path)
          uri, query_string = path.split("?")
          return uri if query_string.nil?
          query_string_pairs = query_string.split("&").sort.map{|e| e.split("=") }
          tm_query_string = query_string_pairs.map{|x| "#{x.first.downcase}:#{x.last}" }.join("\n")
          "#{uri.downcase}\n#{tm_query_string}\n"
        end
      end


    end
  end
end
