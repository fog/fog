module Fog
  class Vcloud
    module Terremark
      class Ecloud < Fog::Service

        class UnsupportedVersion < Exception ; end

        requires   :username, :password, :versions_uri
        recognizes :module, :version

        model_path 'fog/vcloud/terremark/ecloud/models'
        model :catalog_item
        model :catalog
        model :firewall_acl
        collection :firewall_acls
        model :internet_service
        collection :internet_services
        model :backup_internet_service
        collection :backup_internet_services
        model :ip
        collection :ips
        model :network
        collection :networks
        model :node
        collection :nodes
        model :public_ip
        collection :public_ips
        model :server
        collection :servers
        model :task
        collection :tasks
        model :vdc
        collection :vdcs

        request_path 'fog/vcloud/terremark/ecloud/requests'
        request :add_internet_service
        request :add_backup_internet_service
        request :add_node
        request :clone_vapp
        request :configure_internet_service
        request :configure_network
        request :configure_network_ip
        request :configure_node
        request :configure_vapp
        request :delete_internet_service
        request :delete_node
        request :delete_vapp
        request :get_catalog
        request :get_catalog_item
        request :get_customization_options
        request :get_firewall_acls
        request :get_firewall_acl
        request :get_internet_services
        request :get_network
        request :get_network_ip
        request :get_network_ips
        request :get_network_extensions
        request :get_organization
        request :get_node
        request :get_nodes
        request :get_public_ip
        request :get_public_ips
        request :get_task
        request :get_task_list
        request :get_vapp
        request :get_vapp_template
        request :get_vdc
        request :get_versions
        request :instantiate_vapp_template
        request :login
        request :power_off
        request :power_on
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
            @login_results = login
            @cookie = @login_results.headers['Set-Cookie']
          end

          def ecloud_xmlns
            {
              "xmlns"     => "urn:tmrk:eCloudExtensions-2.6",
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

        end

        class Mock
          include Shared
          include MockDataClasses

          def self.base_url
            "https://fakey.com/api/v0.8b-ext2.6"
          end

          def self.data_reset
            @mock_data = nil
          end

          def self.data( base_url = self.base_url )
            @mock_data ||= MockData.new.tap do |vcloud_mock_data|
              vcloud_mock_data.versions.clear
              vcloud_mock_data.versions << MockVersion.new(:version => "v0.8b-ext2.6", :supported => true)

              vcloud_mock_data.organizations << MockOrganization.new(:name => "Boom Inc.").tap do |mock_organization|
                mock_organization.vdcs << MockVdc.new(:name => "Boomstick").tap do |mock_vdc|
                  mock_vdc.catalog.items << MockCatalogItem.new(:name => "Item 0").tap do |mock_catalog_item|
                    mock_catalog_item.disks << MockVirtualMachineDisk.new(:size => 25 * 1024)
                  end
                  mock_vdc.catalog.items << MockCatalogItem.new(:name => "Item 1").tap do |mock_catalog_item|
                    mock_catalog_item.disks << MockVirtualMachineDisk.new(:size => 25 * 1024)
                  end
                  mock_vdc.catalog.items << MockCatalogItem.new(:name => "Item 2").tap do |mock_catalog_item|
                    mock_catalog_item.disks << MockVirtualMachineDisk.new(:size => 25 * 1024)
                  end

                  mock_vdc.networks << MockNetwork.new({ :subnet => "1.2.3.0/24" }, mock_vdc)
                  mock_vdc.networks << MockNetwork.new({ :subnet => "4.5.6.0/24" }, mock_vdc)

                  mock_vdc.virtual_machines << MockVirtualMachine.new({ :name => "Broom 1", :ip => "1.2.3.3" }, mock_vdc)
                  mock_vdc.virtual_machines << MockVirtualMachine.new({ :name => "Broom 2", :ip => "1.2.3.4" }, mock_vdc)
                  mock_vdc.virtual_machines << MockVirtualMachine.new({ :name => "Email!", :ip => "1.2.3.10" }, mock_vdc)
                end

                mock_organization.vdcs << MockVdc.new(:name => "Rock-n-Roll", :storage_allocated => 150, :storage_used => 40, :cpu_allocated => 1000, :memory_allocated => 2048).tap do |mock_vdc|
                  mock_vdc.networks << MockNetwork.new({ :subnet => "7.8.9.0/24" }, mock_vdc)

                  mock_vdc.virtual_machines << MockVirtualMachine.new({ :name => "Master Blaster", :ip => "7.8.9.10" }, mock_vdc)
                end
              end

              vcloud_mock_data.organizations.detect {|o| o.name == "Boom Inc." }.tap do |mock_organization|
                mock_organization.vdcs.detect {|v| v.name == "Boomstick" }.tap do |mock_vdc|
                  mock_vdc.public_ip_collection.items << MockPublicIp.new(:name => "99.1.2.3").tap do |mock_public_ip|
                    mock_public_ip.internet_service_collection.items << MockPublicIpInternetService.new({
                                                                                                          :protocol => "HTTP",
                                                                                                          :port => 80,
                                                                                                          :name => "Web Site",
                                                                                                          :description => "Web Servers",
                                                                                                          :redirect_url => "http://fakey.com"
                                                                                                        }, mock_public_ip.internet_service_collection
                                                                                                        ).tap do |mock_public_ip_service|
                      mock_public_ip_service.node_collection.items << MockPublicIpInternetServiceNode.new({:ip_address => "1.2.3.5", :name => "Test Node 1", :description => "web 1"}, mock_public_ip_service.node_collection)
                      mock_public_ip_service.node_collection.items << MockPublicIpInternetServiceNode.new({:ip_address => "1.2.3.6", :name => "Test Node 2", :description => "web 2"}, mock_public_ip_service.node_collection)
                      mock_public_ip_service.node_collection.items << MockPublicIpInternetServiceNode.new({:ip_address => "1.2.3.7", :name => "Test Node 3", :description => "web 3"}, mock_public_ip_service.node_collection)
                    end

                    mock_public_ip.internet_service_collection.items << MockPublicIpInternetService.new({
                                                                                                          :protocol => "TCP",
                                                                                                          :port => 7000,
                                                                                                          :name => "An SSH Map",
                                                                                                          :description => "SSH 1"
                                                                                                        }, mock_public_ip.internet_service_collection
                                                                                                        ).tap do |mock_public_ip_service|
                      mock_public_ip_service.node_collection.items << MockPublicIpInternetServiceNode.new({ :ip_address => "1.2.3.5", :port => 22, :name => "SSH", :description => "web ssh" }, mock_public_ip_service.node_collection)
                    end
                  end

                  mock_vdc.public_ip_collection.items << MockPublicIp.new(:name => "99.1.2.4").tap do |mock_public_ip|
                    mock_public_ip.internet_service_collection.items << MockPublicIpInternetService.new({
                                                                                                          :protocol => "HTTP",
                                                                                                          :port => 80,
                                                                                                          :name => "Web Site",
                                                                                                          :description => "Web Servers",
                                                                                                          :redirect_url => "http://fakey.com"
                                                                                                        }, mock_public_ip.internet_service_collection
                                                                                                        )

                    mock_public_ip.internet_service_collection.items << MockPublicIpInternetService.new({
                                                                                                          :protocol => "TCP",
                                                                                                          :port => 7000,
                                                                                                          :name => "An SSH Map",
                                                                                                          :description => "SSH 2"
                                                                                                        }, mock_public_ip.internet_service_collection
                                                                                                        )
                  end

                  mock_vdc.public_ip_collection.items << MockPublicIp.new(:name => "99.1.9.7")

                  mock_vdc.internet_service_collection.backup_internet_services << MockBackupInternetService.new({ :port => 10000, :protocol => "TCP"}, self)
                end

                mock_organization.vdcs.detect {|v| v.name == "Rock-n-Roll" }.tap do |mock_vdc|
                  mock_vdc.public_ip_collection.items << MockPublicIp.new(:name => "99.99.99.99")
                end
              end

              vcloud_mock_data.organizations.each do |organization|
                organization.vdcs.each do |vdc|
                  vdc.networks.each do |network|
                    network[:rnat] = vdc.public_ip_collection.items.first.name
                  end
                  vdc.virtual_machines.each do |virtual_machine|
                    virtual_machine.disks << MockVirtualMachineDisk.new(:size => 25 * 1024)
                    virtual_machine.disks << MockVirtualMachineDisk.new(:size => 50 * 1024)
                  end
                end
              end
            end
          end

          def initialize(options = {})
            @versions_uri = URI.parse('https://vcloud.fakey.com/api/versions')
          end

          def mock_data
            Fog::Vcloud::Terremark::Ecloud::Mock.data
          end

          def mock_error(expected, status, body='', headers={})
            raise Excon::Errors::Unauthorized.new("Expected(#{expected}) <=> Actual(#{status})")
          end

          def mock_it(status, mock_data, mock_headers = {})
            response = Excon::Response.new

            #Parse the response body into a hash
            if mock_data.empty?
              response.body = mock_data
            else
              document = Fog::ToHashDocument.new
              parser = Nokogiri::XML::SAX::PushParser.new(document)
              parser << mock_data
              parser.finish
              response.body = document.body
            end

            response.status = status
            response.headers = mock_headers
            response
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
                    :method  => '#{args[2] || 'GET'}',
                    :headers => #{args[3] ? args[3].inspect : '{}'},
                    :body => '#{args[4] ? args[4] : ''}',
                    :parse => true,
                    :uri     => uri })
                end
              EOS
            end

            def unauthenticated_basic_request(*args)
              self.class_eval <<-EOS, __FILE__,__LINE__
                def #{args[0]}(uri)
                  unauthenticated_request({
                    :expects => #{args[1] || 200},
                    :method  => '#{args[2] || 'GET'}',
                    :headers => #{args[3] ? args[3].inspect : '{}'},
                    :parse => true,
                    :uri     => uri })
                end
              EOS
            end

          end

          def initialize(options = {})
            @connections = {}
            @versions_uri = URI.parse(options[:versions_uri])
            @module = options[:module]
            @version = options[:version]
            @username = options[:username]
            @password = options[:password]
            @persistent = options[:persistent]
          end

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

          def reload
            @connections.each_value { |k,v| v.reset if v }
          end

          # If the cookie isn't set, do a get_organizations call to set it
          # and try the request.
          # If we get an Unauthorized error, we assume the token expired, re-auth and try again
          def request(params)
            unless @cookie
              do_login
            end
            begin
              do_request(params)
            rescue Excon::Errors::Unauthorized => e
              do_login
              do_request(params)
            end
          end

          def supporting_versions
            ["v0.8b-ext2.6", "0.8b-ext2.6"]
          end

          private

          def ensure_parsed(uri)
            if uri.is_a?(String)
              URI.parse(uri)
            else
              uri
            end
          end

          def supported_version_numbers
            case supported_versions
            when Array
              supported_versions.map { |version| version[:Version] }
            when Hash
              [ supported_versions[:Version] ]
            end
          end

          def get_login_uri
            check_versions
            URI.parse case supported_versions
            when Array
              supported_versions.detect {|version| version[:Version] == @version }[:LoginUrl]
            when Hash
              supported_versions[:LoginUrl]
            end
          end

          # If we don't support any versions the service does, then raise an error.
          # If the @version that super selected isn't in our supported list, then select one that is.
          def check_versions
            if @version
              unless supported_version_numbers.include?(@version.to_s)
                raise UnsupportedVersion.new("#{@version} is not supported by the server.")
              end
              unless supporting_versions.include?(@version.to_s)
                raise UnsupportedVersion.new("#{@version} is not supported by #{self.class}")
              end
            else
              unless @version = (supported_version_numbers & supporting_versions).sort.first
                raise UnsupportedVersion.new("\nService @ #{@versions_uri} supports: #{supported_version_numbers.join(', ')}\n" +
                                             "#{self.class} supports: #{supporting_versions.join(', ')}")
              end
            end
          end

          # Don't need to  set the cookie for these or retry them if the cookie timed out
          def unauthenticated_request(params)
            do_request(params)
          end

          # Use this to set the Authorization header for login
          def authorization_header
            "Basic #{Base64.encode64("#{@username}:#{@password}").chomp!}"
          end

          def login_uri
            @login_uri ||= get_login_uri
          end

          # login handles the auth, but we just need the Set-Cookie
          # header from that call.
          def do_login
            @login_results = login
            @cookie = @login_results.headers['Set-Cookie']
          end

          # Actually do the request
          def do_request(params)
            # Convert the uri to a URI if it's a string.
            if params[:uri].is_a?(String)
              params[:uri] = URI.parse(params[:uri])
            end
            host_url = "#{self.scheme}://#{self.host}#{self.port ? ":#{self.port}" : ''}"

            # Hash connections on the host_url ... There's nothing to say we won't get URI's that go to
            # different hosts.
            @connections[host_url] ||= Fog::Connection.new(host_url, @persistent)

            # Set headers to an empty hash if none are set.
            headers = params[:headers] || {}

            # Add our auth cookie to the headers
            if @cookie
              headers.merge!('Cookie' => @cookie)
            end

            # Make the request
            response = @connections[host_url].request({
              :body     => params[:body] || '',
              :expects  => params[:expects] || 200,
              :headers  => headers,
              :method   => params[:method] || 'GET',
              :path     => params[:uri].path
            })

            # Parse the response body into a hash
            #puts response.body
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

        end

      end
    end
  end
end
