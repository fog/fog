require 'fog/ecloud/core'
require 'fog/ecloud/collection'
require 'fog/ecloud/model'
require 'builder'

module Fog
  module Compute
    class Ecloud < Fog::Service
      API_URL = "https://services.enterprisecloud.terremark.com"

      attr_reader :authentication_method, :version

      #### Credentials
      #requires
      recognizes :ecloud_username, :ecloud_password, :ecloud_version,
                 :ecloud_access_key, :ecloud_private_key,
                 :ecloud_authentication_method, :base_path

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
      model :virtual_machine_assigned_ip
      collection :virtual_machine_assigned_ips
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
      model :detached_disk
      collection :detached_disks

      #### Requests
      request_path 'fog/ecloud/requests/compute'
      request :backup_internet_service_create
      request :backup_internet_service_delete
      request :backup_internet_service_edit
      request :compute_pool_edit
      request :firewall_acls_create
      request :firewall_acls_delete
      request :get_admin_organization
      request :get_api_key
      request :get_api_keys
      request :get_association
      request :get_associations
      request :get_authentication_level
      request :get_authentication_levels
      request :get_backup_internet_service
      request :get_backup_internet_services
      request :get_catalog
      request :get_catalog_configuration
      request :get_catalog_configurations
      request :get_catalog_item
      request :get_compute_pool
      request :get_compute_pools
      request :get_cpu_usage_detail
      request :get_cpu_usage_detail_summary
      request :get_environment
      request :get_firewall_acl
      request :get_firewall_acls
      request :get_group
      request :get_groups
      request :get_guest_process
      request :get_guest_processes
      request :get_hardware_configuration
      request :get_internet_service
      request :get_internet_services
      request :get_ip_address
      request :get_layout
      request :get_layouts
      request :get_location
      request :get_locations
      request :get_login_banner
      request :get_login_banners
      request :get_memory_usage_detail
      request :get_memory_usage_detail_summary
      request :get_monitor
      request :get_monitors
      request :get_network
      request :get_network_summary
      request :get_networks
      request :get_node
      request :get_nodes
      request :get_operating_system
      request :get_operating_system_families
      request :get_organization
      request :get_organizations
      request :get_password_complexity_rule
      request :get_password_complexity_rules
      request :get_physical_device
      request :get_physical_devices
      request :get_public_ip
      request :get_public_ips
      request :get_rnat
      request :get_rnats
      request :get_role
      request :get_roles
      request :get_row
      request :get_rows
      request :get_server
      request :get_server_configuration_option
      request :get_server_configuration_options
      request :get_servers
      request :get_ssh_key
      request :get_ssh_keys
      request :get_storage_usage_detail
      request :get_storage_usage_detail_summary
      request :get_support_ticket
      request :get_support_tickets
      request :get_tag
      request :get_tags
      request :get_task
      request :get_tasks
      request :get_template
      request :get_templates
      request :get_trusted_network_group
      request :get_trusted_network_groups
      request :get_user
      request :get_users
      request :get_virtual_machine_assigned_ips
      request :get_detached_disks
      request :get_detached_disk
      request :groups_create
      request :groups_delete
      request :groups_edit
      request :groups_movedown
      request :groups_moveup
      request :internet_service_create
      request :internet_service_delete
      request :internet_service_edit
      request :monitors_create_default
      request :monitors_create_ecv
      request :monitors_create_http
      request :monitors_create_loopback
      request :monitors_create_ping
      request :monitors_disable
      request :monitors_edit_ecv
      request :monitors_edit_http
      request :monitors_edit_ping
      request :monitors_enable
      request :node_service_create
      request :node_service_delete
      request :node_service_edit
      request :power_off
      request :power_on
      request :power_reset
      request :power_shutdown
      request :public_ip_activate
      request :rnat_associations_create_device
      request :rnat_associations_delete
      request :rnat_associations_edit_network
      request :rows_create
      request :rows_delete
      request :rows_edit
      request :rows_movedown
      request :rows_moveup
      request :trusted_network_groups_create
      request :trusted_network_groups_delete
      request :trusted_network_groups_edit
      request :virtual_machine_edit_assigned_ips
      request :virtual_machine_copy
      request :virtual_machine_copy_identical
      request :virtual_machine_create_from_template
      request :virtual_machine_delete
      request :virtual_machine_edit
      request :virtual_machine_edit_hardware_configuration
      request :virtual_machine_import
      request :virtual_machine_upload_file
      request :virtual_machine_detach_disk
      request :virtual_machine_attach_disk

      module Shared
        attr_accessor :base_path
        attr_reader :versions_uri

        def validate_data(required_opts = [], options = {})
          unless required_opts.all? { |opt| options.key?(opt) }
            raise ArgumentError.new("Required data missing: #{(required_opts - options.keys).map(&:inspect).join(", ")}")
          end
        end

        def id_from_uri(uri)
          uri.match(/(\d+)$/)[1].to_i
        end

        def default_organization_uri
          "#{@base_path}/organizations"
        end
      end

      class Real
        include Shared

        class << self
          def basic_request(name, expects=[200], method=:get, headers={}, body='')
            define_method(name) do |uri|
              request({
                :expects => expects,
                :method  => method,
                :headers => headers,
                :body    => body,
                :parse   => true,
                :uri     => uri
              })
            end
          end
        end

        def initialize(options = {})
          @base_path               = options[:base_path] || '/cloudapi/ecloud'
          @connections             = {}
          @connection_options      = options[:connection_options] || {}
          @host                    = options[:ecloud_host] || API_URL
          @persistent              = options[:persistent] || false
          @version                 = options[:ecloud_version] || "2013-06-01"
          @authentication_method   = options[:ecloud_authentication_method] || :cloud_api_auth
          @access_key              = options[:ecloud_access_key]
          @private_key             = options[:ecloud_private_key]
          if @private_key.nil? || @authentication_method == :basic_auth
            @authentication_method = :basic_auth
            @username              = options[:ecloud_username]
            @password              = options[:ecloud_password]
            if @username.nil? || @password.nil?
              raise ArgumentError, "No credentials (cloud auth, or basic auth) passed!"
            end
          else
            @hmac = Fog::HMAC.new("sha256", @private_key)
          end
        end

        def request(params)
          # Convert the uri to a URI if it's a string.
          if params[:uri].is_a?(String)
            params[:uri] = URI.parse(@host + params[:uri])
          end
          host_url = "#{params[:uri].scheme}://#{params[:uri].host}#{params[:uri].port ? ":#{params[:uri].port}" : ''}"

          # Hash connections on the host_url ... There's nothing to say we won't get URI's that go to
          # different hosts.
          @connections[host_url] ||= Fog::XML::Connection.new(host_url, @persistent, @connection_options)

          # Set headers to an empty hash if none are set.
          headers = set_extra_headers_for(params) || set_extra_headers_for({})

          # Make the request
          options = {
            :expects => (params[:expects] || 200),
            :method  => params[:method] || 'GET',
            :path    => params[:uri].path + "#{"?#{params[:uri].query}" if params[:uri].query}",
            :headers => headers
          }
          unless params[:body].nil? || params[:body].empty?
            options.merge!({:body => params[:body]})
          end
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
          params[:headers] = {
            'x-tmrk-version' => @version,
            'Date'           => Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S GMT"),
          }.merge(params[:headers] || {})
          if params[:method]=="POST" || params[:method]=="PUT"
            params[:headers].merge!({"Content-Type" => 'application/xml'}) unless params[:headers]['Content-Type']
            params[:headers].merge!({"Accept" => 'application/xml'})
          end
          unless params[:body].nil? || params[:body].empty?
            params[:headers].merge!({"x-tmrk-contenthash" => "Sha256 #{Base64.encode64(Digest::SHA2.digest(params[:body].to_s)).chomp}"})
          end
          if @authentication_method == :basic_auth
            params[:headers].merge!({'Authorization' => "Basic #{Base64.encode64(@username+":"+@password).delete("\r\n")}"})
          elsif @authentication_method == :cloud_api_auth
            signature = cloud_api_signature(params)
            params[:headers].merge!({
              "x-tmrk-authorization" => %{CloudApi AccessKey="#{@access_key}" SignatureType="HmacSha256" Signature="#{signature}"},
              "Authorization" => %{CloudApi AccessKey="#{@access_key}" SignatureType="HmacSha256" Signature="#{signature}"}
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
          string = [
            verb,
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
          tmp = headers.reduce({}) {|ret, h| ret[h.first.downcase] = h.last if h.first.match(/^x-tmrk/i) ; ret }
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

      class Mock
        include Shared

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = begin
                          compute_pool_id            = Fog.credentials[:ecloud_compute_pool_id]  || Fog::Mock.random_numbers(3).to_i
                          environment_id             = Fog.credentials[:ecloud_environment_id]   || Fog::Mock.random_numbers(3).to_i
                          public_ip_id               = Fog.credentials[:ecloud_public_ip_id]     || Fog::Mock.random_numbers(6).to_i
                          internet_service_id        = Fog::Mock.random_numbers(6).to_i
                          node_service_id            = Fog::Mock.random_numbers(6).to_i
                          environment_name           = Fog.credentials[:ecloud_environment_name] || Fog::Mock.random_letters(12)
                          location_id                = Fog::Mock.random_numbers(4).to_i
                          network_id                 = Fog.credentials[:ecloud_network_id]       || Fog::Mock.random_numbers(6).to_i
                          network_ip                 = Fog::Ecloud.ip_address
                          public_ip                  = Fog.credentials[:ecloud_public_ip_name]   || Fog::Ecloud.ip_address
                          ip_address_id              = Fog::Ecloud.ip_address
                          ip_address2_id             = Fog::Ecloud.ip_address
                          operating_system_id        = Fog::Mock.random_numbers(7).to_i
                          operating_system_family_id = Fog::Mock.random_numbers(7).to_i
                          organization_id            = Fog::Mock.random_numbers(7).to_i
                          organization_name          = Fog::Mock.random_letters(7)
                          template_id                = Fog.credentials[:ecloud_template_id]      || Fog::Mock.random_numbers(7).to_i
                          ssh_key_id                 = Fog.credentials[:ecloud_ssh_key_id]       || Fog::Mock.random_numbers(4).to_i
                          ssh_key_name               = Fog.credentials[:ecloud_ssh_key_name]     || "root"

                          environment = {
                            :id   => environment_id,
                            :href => "/cloudapi/ecloud/environments/#{environment_id}",
                            :name => environment_name,
                            :type => "application/vnd.tmrk.cloud.environment"
                          }

                          organization = {
                            :href => "/cloudapi/ecloud/organizations/#{organization_id}",
                            :type => "application/vnd.tmrk.cloud.organization",
                            :name => organization_name,
                            :Links => {
                              :Link => [
                                Fog::Ecloud.keep(environment, :href, :name, :type),
                                {
                                  :href => "/cloudapi/ecloud/admin/organizations/#{organization_id}",
                                  :name => organization_name,
                                  :type => "application/vnd.tmrk.cloud.admin.organization",
                                  :rel  => "alternate",
                                },
                                {
                                  :href => "/cloudapi/ecloud/devicetags/organizations/#{organization_id}",
                                  :type => "application/vnd.tmrk.cloud.deviceTag; type=collection",
                                  :rel  => "down",
                                },
                                {
                                  :href => "/cloudapi/ecloud/alerts/organizations/#{organization_id}",
                                  :type => "application/vnd.tmrk.cloud.alertLog",
                                  :rel  => "down",
                                },
                              ],
                            },
                            :Locations => {
                              :Location => [
                                {
                                  :href => "/cloudapi/ecloud/locations/#{location_id}",
                                  :name => organization_name,
                                  :Catalog => {
                                    :href => "/cloudapi/ecloud/admin/catalog/organizations/#{organization_id}/locations/#{location_id}",
                                  :type => "application/vnd.tmrk.cloud.admin.catalogEntry; type=collection"
                                  },
                                  :Environments => { :Environment => [environment] }
                                }
                              ]
                            }
                          }
                          environment.merge!(
                            :Links => {
                              :Link => [ Fog::Ecloud.keep(organization, :href, :name, :type), ]
                            }
                          )

                          admin_organization = {
                            :id    => organization_id,
                            :href  => "/cloudapi/ecloud/admin/organizations/#{organization_id}",
                            :type  => "application/vnd.tmrk.cloud.admin.organization",
                            :name  => organization_name,
                            :Links => {
                              :Link => [
                                Fog::Ecloud.keep(organization, :href, :type, :name)
                              ],
                            },
                            :organization_id => organization_id,
                          }

                          compute_pool = {
                            :id             => compute_pool_id,
                            :href           => "/cloudapi/ecloud/computepools/#{compute_pool_id}",
                            :name           => Fog::Mock.random_letters(12),
                            :type           => "application/vnd.tmrk.cloud.computePool",
                            :environment_id => environment_id,
                            :Links          => {
                              :Link => [
                                Fog::Ecloud.keep(organization, :href, :name, :type),
                                Fog::Ecloud.keep(environment, :href, :name, :type),
                              ]
                            }
                          }

                          public_ip = {
                            :id             => public_ip_id,
                            :href           => "/cloudapi/ecloud/publicips/#{public_ip_id}",
                            :name           => public_ip,
                            :type           => "application/vnd.tmrk.cloud.publicIp",
                            :IpType         => "none",
                            :environment_id => environment_id,
                            :Links          => {
                              :Link => [
                                Fog::Ecloud.keep(environment, :href, :name, :type),
                              ],
                            },
                            :InternetServices => {
                              :InternetService => [
                              ],
                            },
                          }

                          internet_service = {
                            :id           => internet_service_id,
                            :href         => "/cloudapi/ecloud/internetservices/#{internet_service_id}",
                            :name         => Fog::Mock.random_letters(6),
                            :type         => "application/vnd.tmrk.cloud.internetService",
                            :public_ip_id => public_ip_id,
                            :Links => {
                              :Link => [
                                Fog::Ecloud.keep(public_ip, :href, :name, :type),
                              ],
                            },
                            :NodeServices => {
                              :NodeService => [
                              ]
                            },
                          }

                          node_service = {
                            :id                  => node_service_id,
                            :href                => "/cloudapi/ecloud/nodeservices/#{node_service_id}",
                            :name                => Fog::Mock.random_letters(6),
                            :type                => "application/vnd.tmrk.cloud.nodeService",
                            :internet_service_id => internet_service_id,
                            :Links               => {
                              :Link => [
                                Fog::Ecloud.keep(internet_service, :href, :name, :type)
                              ],
                            },
                          }

                          internet_service[:NodeServices][:NodeService].push(node_service)
                          public_ip[:InternetServices][:InternetService].push(internet_service)

                          network = {
                            :id               => network_id,
                            :href             => "/cloudapi/ecloud/networks/#{network_id}",
                            :name             => "#{network_ip}/#{Fog::Mock.random_numbers(2)}",
                            :type             => "application/vnd.tmrk.cloud.network",
                            :Address          => network_ip,
                            :NetworkType      => "Dmz",
                            :BroadcastAddress => network_ip,
                            :GatewayAddress   => network_ip,
                            :environment_id   => environment_id,
                            :Links => {
                              :Link => [
                                Fog::Ecloud.keep(environment, :href, :name, :type),
                              ]
                            },
                            :IpAddresses => {
                              :IpAddress => [],
                            },
                          }

                          ip_address = {
                              :id         => ip_address_id,
                              :href       => "/cloudapi/ecloud/ipaddresses/networks/#{network_id}/#{ip_address_id}",
                              :name       => ip_address_id,
                              :type       => "application/vnd.tmrk.cloud.ipAddress",
                              :network_id => network_id,
                              :Links      => {
                                :Link     => [ Fog::Ecloud.keep(network, :href, :name, :type), ],
                              },
                              :Reserved   => "false",
                              :Host       => nil,
                              :DetectedOn => nil,
                          }

                          ip_address2 = ip_address.dup.merge(:id => ip_address2_id, :href => "/cloudapi/ecloud/ipaddresses/networks/#{network_id}/#{ip_address2_id}", :name => ip_address2_id)

                          network[:IpAddresses][:IpAddress].push(ip_address).push(ip_address2)

                          short_name = "solaris10_64guest"
                          operating_system = {
                            :short_name      => short_name,
                            :compute_pool_id => compute_pool_id,
                            :href            => "/cloudapi/ecloud/operatingsystems/#{short_name}/computepools/#{compute_pool_id}",
                            :name            => "Sun Solaris 10 (64-bit)",
                            :type            => "application/vnd.tmrk.cloud.operatingSystem",
                            :FamilyName      => "Solaris",
                            :Links           => {
                              :Link => Fog::Ecloud.keep(compute_pool, :href, :name, :type),
                            },
                            :ConfigurationOptions => {
                              :Processor => {
                                :Minimum    => "1",
                                :Maximum    => "8",
                                :StepFactor => "1"
                              },
                              :Memory => {
                                :MinimumSize => {
                                  :Unit  => "MB",
                                  :Value => "800"
                                },
                                :MaximumSize => {
                                  :Unit  => "MB",
                                  :Value => "16384"
                                },
                                :StepFactor => {
                                  :Unit  => "MB",
                                  :Value => "4"
                                }
                              },
                              :Disk => {
                                :Minimum => "1",
                                :Maximum => "15",
                                :SystemDisk => {
                                  :ResourceCapacityRange => {
                                    :MinimumSize => {
                                      :Unit => "GB",
                                      :Value => "1"
                                    },
                                    :MaximumSize => {
                                      :Unit => "GB",
                                      :Value => "512"
                                    },
                                    :StepFactor => {
                                      :Unit => "GB",
                                      :Value => "1"}
                                  },
                                  :MonthlyCost => "0"
                                },
                                :DataDisk => {
                                  :ResourceCapacityRange => {
                                    :MinimumSize => {
                                      :Unit => "GB",
                                      :Value => "1"
                                    },
                                    :MaximumSize => {
                                      :Unit => "GB",
                                      :Value => "512"
                                    },
                                    :StepFactor => {
                                      :Unit  => "GB",
                                      :Value => "1"
                                    }
                                  },
                                  :MonthlyCost => "0"
                                }
                              },
                              :NetworkAdapter=> {
                                :Minimum    => "1",
                                :Maximum    => "4",
                                :StepFactor => "1"
                              }
                            }
                          }

                          template = {
                            :id              => template_id,
                            :href            => "/cloudapi/ecloud/templates/#{template_id}/computepools/#{compute_pool_id}",
                            :type            => "application/vnd.tmrk.cloud.template",
                            :name            => "Sun Solaris 10 (x64)",
                            :compute_pool_id => compute_pool_id,
                            :OperatingSystem => Fog::Ecloud.keep(operating_system, :href, :name, :type),
                            :Memory => {
                              :MinimumSize => {
                                :Unit  => "MB",
                                :Value => "800"
                              },
                              :MaximumSize => {
                                :Unit  => "MB",
                                :Value => "16384"
                              },
                              :StepFactor => {
                                :Unit  => "MB",
                                :Value => "4"
                              }
                            },
                            :Storage => {
                              :Size => {
                                :Unit  => "GB",
                                :Value => "7"
                              }
                            },
                            :NetworkAdapters => "1",
                            :Links           => {
                              :Link => [
                                Fog::Ecloud.keep(compute_pool, :href, :name, :type),
                              ]
                            }
                          }

                          operating_system_family = {
                            :id                    => operating_system_family_id,
                            :compute_pool_id       => compute_pool_id,
                            :OperatingSystemFamily => {
                              :Name             => "Linux",
                              :OperatingSystems => {
                                :OperatingSystem => [Fog::Ecloud.keep(operating_system, :href, :name, :type)],
                              }
                            },
                            :Links => {
                              :Link => [
                                Fog::Ecloud.keep(compute_pool, :href, :name, :type),
                              ]
                            }
                          }

                          ssh_key = {
                            :id                    => ssh_key_id,
                            :href                  => "/cloudapi/ecloud/admin/sshKeys/#{ssh_key_id}",
                            :name                  => ssh_key_name,
                            :admin_organization_id => organization_id,
                            :Links => {
                              :Link => [
                                Fog::Ecloud.keep(admin_organization, :href, :name, :type),
                                Fog::Ecloud.keep(organization, :href, :name, :type),
                              ]
                            },
                            :Default => "true",
                            :FingerPrint => Fog::Ecloud.mac_address
                          }

                          layout = {
                            :id => environment_id,
                            :href => "/cloudapi/ecloud/layout/environments/#{environment_id}",
                            :type => "application/vnd.tmrk.cloud.deviceLayout",
                            :Links => {
                              :Link => [
                                Fog::Ecloud.keep(environment, :name, :href, :type),
                              ],
                            },
                            :Rows => {
                              :Row => [
                              ],
                            },
                            :environment_id => environment_id
                          }

                          {
                            :compute_pools             => {compute_pool_id            => compute_pool},
                            :environments              => {environment_id             => environment},
                            :public_ips                => {public_ip_id               => public_ip},
                            :internet_services         => {internet_service_id        => internet_service},
                            :node_services             => {node_service_id            => node_service},
                            :networks                  => {network_id                 => network},
                            :organizations             => {organization_id            => organization},
                            :admin_organizations       => {organization_id            => admin_organization},
                            :operating_systems         => {operating_system_id        => operating_system},
                            :operating_system_families => {operating_system_family_id => operating_system_family},
                            :servers                   => {},
                            :tasks                     => {},
                            :templates                 => {template_id                => template},
                            :ssh_keys                  => {ssh_key_id                 => ssh_key},
                            :detached_disks            => {},
                            :template_href             => (Fog.credentials[:ecloud_template_href] || "/cloudapi/ecloud/templates/#{template_id}/computepools/#{compute_pool_id}"),
                            :rows                      => {},
                            :groups                    => {},
                            :layouts                   => {environment_id             => layout},
                          }
                        end
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @base_path = '/cloudapi/ecloud'
          @ecloud_api_key = options[:ecloud]
        end

        def data
          self.class.data[@ecloud_api_key]
        end

        def reset_data
          self.class.data.delete(@ecloud_api_key)
        end

        def response(params={})
          body    = params[:body]
          headers = {
            "Content-Type" => "application/xml"
          }.merge(params[:headers] || {})
          status  = params[:status] || 200

          response = Excon::Response.new(:body => body, :headers => headers, :status => status)
          if params.key?(:expects) && ![*params[:expects]].include?(response.status)
            raise(Excon::Errors.status_error(params, response))
          else response
          end
        end

        def deep_copy(o)
          Marshal.load(Marshal.dump(o))
        end
      end
    end
  end
end
