require 'fog/vcloud_director/core'
require 'fog/vcloud_director/query'

class VcloudDirectorParser < Fog::Parsers::Base
  def extract_attributes(attributes_xml)
    attributes = {}
    until attributes_xml.empty?
      if attributes_xml.first.is_a?(Array)
        until attributes_xml.first.empty?
          attribute = attributes_xml.first.shift
          attributes[attribute.localname.to_sym] = attribute.value
        end
      else
        attribute = attributes_xml.shift
        attributes[attribute.localname.to_sym] = attribute.value
      end
    end
    attributes
  end
end

class NonLoaded
end

module Fog
  module Compute
    class VcloudDirector < Fog::Service
      module Defaults
        PATH        = '/api'
        PORT        = 443
        SCHEME      = 'https'
        API_VERSION = '5.1'
        OMIT_DEFAULT_PORT = true
      end

      class ServiceError < Fog::VcloudDirector::Errors::ServiceError; end

      class BadRequest < Fog::VcloudDirector::Errors::BadRequest; end
      class Unauthorized < Fog::VcloudDirector::Errors::Unauthorized; end
      class Forbidden < Fog::VcloudDirector::Errors::Forbidden; end
      class Conflict < Fog::VcloudDirector::Errors::Conflict; end
      class MalformedResponse < Fog::VcloudDirector::Errors::MalformedResponse; end

      class DuplicateName < Fog::VcloudDirector::Errors::DuplicateName; end
      class TaskError < Fog::VcloudDirector::Errors::TaskError; end

      requires :vcloud_director_username, :vcloud_director_password, :vcloud_director_host
      recognizes :vcloud_director_api_version, :vcloud_director_show_progress, :path, :vcloud_token

      secrets :vcloud_director_password

      model_path 'fog/vcloud_director/models/compute'
      model      :catalog
      collection :catalogs
      model      :organization
      collection :organizations
      model      :catalog_item
      collection :vapp_templates
      model      :vapp_template
      collection :template_vms
      model      :template_vm
      collection :catalog_items
      model      :custom_field
      collection :custom_fields
      model      :vdc
      collection :vdcs
      model      :vapp
      collection :vapps
      model      :task
      collection :tasks
      model      :vm
      collection :vms
      model      :vm_customization
      collection :vm_customizations
      model      :network
      collection :networks
      model      :disk
      collection :disks
      model      :vm_network
      collection :vm_networks
      model      :tag # this is called metadata in vcloud
      collection :tags
      model      :media
      collection :medias # sic

      request_path 'fog/vcloud_director/requests/compute'
      request :delete_catalog_item
      request :delete_catalog_item_metadata_item_metadata
      request :delete_disk
      request :delete_disk_metadata_item_metadata
      request :delete_logout
      request :delete_media
      request :delete_media_metadata_item_metadata
      request :delete_network
      request :delete_shadow_vm
      request :delete_vapp
      request :delete_vapp_metadata_item_metadata
      request :delete_vapp_template
      request :delete_vapp_template_metadata_item_metadata
      request :get_allocated_ip_addresses
      request :get_catalog
      request :get_catalog_item
      request :get_catalog_item_metadata
      request :get_catalog_item_metadata_item_metadata
      request :get_catalog_metadata
      request :get_catalog_metadata_item_metadata
      request :get_catalogs_from_query
      request :get_control_access_params_catalog
      request :get_control_access_params_vapp
      request :get_cpu_rasd_item
      request :get_current_session
      request :get_disk
      request :get_disk_metadata
      request :get_disk_metadata_item_metadata
      request :get_disk_owner
      request :get_disks_from_query
      request :get_disks_rasd_items_list
      request :get_edge_gateway
      request :get_entity
      request :get_execute_query
      request :get_groups_from_query
      request :get_guest_customization_system_section_vapp
      request :get_guest_customization_system_section_vapp_template
      request :get_href # this is used for manual testing
      request :get_lease_settings_section_vapp
      request :get_lease_settings_section_vapp_template
      request :get_media
      request :get_media_drives_rasd_items_list
      request :get_media_metadata
      request :get_media_metadata_item_metadata
      request :get_media_owner
      request :get_medias_from_query
      request :get_memory_rasd_item
      request :get_metadata
      request :get_network
      request :get_network_cards_items_list
      request :get_network_complete
      request :get_network_config_section_vapp
      request :get_network_config_section_vapp_template
      request :get_network_connection_system_section_vapp
      request :get_network_connection_system_section_vapp_template
      request :get_network_metadata
      request :get_network_metadata_item_metadata
      request :get_network_section_vapp
      request :get_network_section_vapp_template
      request :get_operating_system_section
      request :get_org_settings
      request :get_org_vdc_gateways
      request :get_organization
      request :get_organization_metadata
      request :get_organization_metadata_item_metadata
      request :get_organizations
      request :get_organizations_from_query
      request :get_product_sections_vapp
      request :get_product_sections_vapp_template
      request :get_request # this is used for manual testing
      request :get_runtime_info_section_type
      request :get_serial_ports_items_list
      request :get_shadow_vm
      request :get_snapshot_section
      request :get_startup_section
      request :get_supported_systems_info
      request :get_supported_versions
      request :get_task
      request :get_task_list
      request :get_template_vm
      request :get_template_vms
      request :get_thumbnail
      request :get_users_from_query
      request :get_vapp
      request :get_vapp_metadata
      request :get_vapp_metadata_item_metadata
      request :get_vapp_ovf_descriptor
      request :get_vapp_owner
      request :get_vapp_template
      request :get_vapp_template_customization_system_section
      request :get_vapp_template_metadata
      request :get_vapp_template_metadata_item_metadata
      request :get_vapp_template_ovf_descriptor
      request :get_vapp_template_owner
      request :get_vapp_templates_from_query
      request :get_vapps_in_lease_from_query
      request :get_vcloud
      request :get_vdc
      request :get_vdc_metadata
      request :get_vdc_metadata_item_metadata
      request :get_vdc_storage_class
      request :get_vdc_storage_class_metadata
      request :get_vdc_storage_class_metadata_item_metadata
      request :get_vdcs_from_query
      request :get_virtual_hardware_section
      request :get_vm
      request :get_vm_capabilities
      request :get_vm_compliance_results
      request :get_vm_customization
      request :get_vm_disks
      request :get_vm_network
      request :get_vm_pending_question
      request :get_vms
      request :get_vms_by_metadata
      request :get_vms_disk_attached_to
      request :get_vms_in_lease_from_query
      request :instantiate_vapp_template # to be deprecated
      request :post_acquire_ticket
      request :post_answer_vm_pending_question
      request :post_attach_disk
      request :post_cancel_task
      request :post_capture_vapp
      request :post_check_vm_compliance
      request :post_clone_media
      request :post_clone_vapp
      request :post_clone_vapp_template
      request :post_configure_edge_gateway_services
      request :post_consolidate_vm_vapp
      request :post_consolidate_vm_vapp_template
      request :post_create_catalog_item
      request :post_create_org_vdc_network
      request :post_deploy_vapp
      request :post_compose_vapp
      request :post_recompose_vapp
      request :post_detach_disk
      request :post_disable_nested_hv
      request :post_disable_vapp_template_download
      request :post_discard_vapp_state
      request :post_eject_cd_rom
      request :post_enable_nested_hv
      request :post_enable_vapp_template_download
      request :post_enter_maintenance_mode
      request :post_exit_maintenance_mode
      request :post_insert_cd_rom
      request :post_install_vmware_tools
      request :post_instantiate_vapp_template
      request :post_login_session
      request :post_power_off_vapp
      request :post_power_on_vapp
      request :post_reboot_vapp
      request :post_reconfigure_vm
      request :post_remove_all_snapshots
      request :post_reset_vapp
      request :post_revert_snapshot
      request :post_shutdown_vapp
      request :post_suspend_vapp
      request :post_undeploy_vapp
      request :post_update_catalog_item_metadata
      request :post_update_disk_metadata
      request :post_update_media_metadata
      request :post_update_vapp_metadata
      request :post_update_vapp_template_metadata
      request :post_upgrade_hw_version
      request :post_upload_disk
      request :post_upload_media
      request :post_upload_vapp_template
      request :post_create_snapshot
      request :put_catalog_item_metadata_item_metadata
      request :put_cpu
      request :put_disk_metadata_item_metadata
      request :put_disks
      request :put_guest_customization_section_vapp
      request :put_media_metadata_item_metadata
      request :put_memory
      request :put_metadata_value # deprecated
      request :put_network
      request :put_network_connection_system_section_vapp
      request :put_product_sections
      request :put_vapp_metadata_item_metadata
      request :put_vapp_name_and_description
      request :put_vapp_template_metadata_item_metadata
      request :put_vm
      request :put_vm_capabilities
      request :put_config_network_section_vapp

      class Model < Fog::Model
        def initialize(attrs={})
          super(attrs)
          lazy_load_attrs.each do |attr|
            attributes[attr]= NonLoaded if attributes[attr].nil?
            make_lazy_load_method(attr)
          end
          self.class.attributes.each {|attr| make_attr_loaded_method(attr)}
        end

        def lazy_load_attrs
          @lazy_load_attrs ||= self.class.attributes - attributes.keys
        end

        def make_lazy_load_method(attr)
          self.class.instance_eval do
            define_method(attr) do
              reload if attributes[attr] == NonLoaded and !@inspecting
              attributes[attr]
            end
          end
        end

        # it adds an attr_loaded? method to know if the value has been loaded
        # yet or not: ie description_loaded?
        def make_attr_loaded_method(attr)
          self.class.instance_eval do
            define_method("#{attr}_loaded?") do
              attributes[attr] != NonLoaded
            end
          end
        end

        def inspect
          @inspecting = true
          out = super
          @inspecting = false
          out
        end
      end

      class Collection < Fog::Collection
        def all(lazy_load=true)
          lazy_load ? index : get_everyone
        end

        def get(item_id)
          item = get_by_id(item_id)
          return nil unless item
          new(item)
        end

        def get_by_name(item_name)
          item_found = item_list.find {|item| item[:name] == item_name}
          return nil unless item_found
          get(item_found[:id])
        end

        def index
          load(item_list)
        end

        def get_everyone
          items = item_list.map {|item| get_by_id(item[:id])}
          load(items)
        end
      end

      class Real
        extend Fog::Deprecation
        deprecate :auth_token, :vcloud_token

        attr_reader :end_point, :api_version, :show_progress
        alias_method :show_progress?, :show_progress

        def initialize(options={})
          @vcloud_director_password = options[:vcloud_director_password]
          @vcloud_director_username = options[:vcloud_director_username]
          @connection_options = options[:connection_options] || {}
          @connection_options[:omit_default_port] = Fog::Compute::VcloudDirector::Defaults::OMIT_DEFAULT_PORT unless @connection_options[:omit_default_port]
          @host       = options[:vcloud_director_host]
          @path       = options[:path]        || Fog::Compute::VcloudDirector::Defaults::PATH
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || Fog::Compute::VcloudDirector::Defaults::PORT
          @scheme     = options[:scheme]      || Fog::Compute::VcloudDirector::Defaults::SCHEME
          @connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
          @end_point = "#{@scheme}://#{@host}#{@path}/"
          @api_version = options[:vcloud_director_api_version] || Fog::Compute::VcloudDirector::Defaults::API_VERSION
          @show_progress = options[:vcloud_director_show_progress]
          @show_progress = $stdin.tty? if @show_progress.nil?
          @vcloud_token  = options[:vcloud_token]
        end

        def vcloud_token
          login if @vcloud_token.nil?
          @vcloud_token
        end

        def org_name
          login if @org_name.nil?
          @org_name
        end

        def user_name
          login if @user_name.nil?
          @user_name
        end

        def reload
          @connection.reset
        end

        def request(params)
          begin
            do_request(params)
          rescue EOFError
            # This error can occur if Vcloud receives a request from a network
            # it deems to be unauthorized; no HTTP response is sent, but the
            # connection is sent a signal to terminate early.
            raise(
              MalformedResponse, "Connection unexpectedly terminated by vcloud"
            )
          # this is to know if Excon::Errors::Unauthorized really happens
          #rescue Excon::Errors::Unauthorized
          #  login
          #  do_request(params)
          end
        end

        # @api private
        def do_request(params)
          headers = {
            'Accept' => "application/*+xml;version=#{@api_version}",
            'x-vcloud-authorization' => vcloud_token
          }
          if params[:path]
            if params[:override_path] == true
              path = params[:path]
            else
              path = "#{@path}/#{params[:path]}"
            end
          else
            path = "#{@path}"
          end
          @connection.request({
            :body       => params[:body],
            :expects    => params[:expects],
            :headers    => headers.merge!(params[:headers] || {}),
            :idempotent => params[:idempotent],
            :method     => params[:method],
            :parser     => params[:parser],
            :path       => path,
            :query      => params[:query]
          })
        rescue Excon::Errors::HTTPStatusError => error
          raise case error
          when Excon::Errors::BadRequest   then BadRequest.slurp(error);
          when Excon::Errors::Unauthorized then Unauthorized.slurp(error);
          when Excon::Errors::Forbidden    then Forbidden.slurp(error);
          when Excon::Errors::Conflict     then Conflict.slurp(error);
          else                                  ServiceError.slurp(error)
          end
        end

        def process_task(response_body)
          task = make_task_object(response_body)
          wait_and_raise_unless_success(task)
          true
        end

        def make_task_object(task_response)
          task_response[:id] = task_response[:href].split('/').last
          tasks.new(task_response)
        end

        def wait_and_raise_unless_success(task)
          task.wait_for { non_running? }
          raise TaskError.new "status: #{task.status}, error: #{task.error}" unless task.success?
        end

        def add_id_from_href!(data={})
          data[:id] = data[:href].split('/').last
        end

        # Compensate for Fog::ToHashDocument shortcomings.
        # @api private
        # @param [Hash] hash
        # @param [String,Symbol] key1
        # @param [String,Symbol] key2
        # @return [Hash]
        def ensure_list!(hash, key1, key2=nil)
          if key2.nil?
            hash[key1] ||= []
            hash[key1] = [hash[key1]] if hash[key1].is_a?(Hash)
          else
            hash[key1] ||= {key2 => []}
            hash[key1] = {key2 => []} if hash[key1].empty?
            hash[key1][key2] = [hash[key1][key2]] if hash[key1][key2].is_a?(Hash)
          end
          hash
        end

        private

        def login
          @vcloud_token ||= ENV['FOG_VCLOUD_TOKEN']
          if @vcloud_token
            response = get_current_session
            session_org = response.body[:org]
            session_user = response.body[:user]

            check_session_matches_credentials(session_org, session_user)
          else
            response = post_login_session
            x_vcloud_authorization = response.headers.keys.find do |key|
              key.downcase == 'x-vcloud-authorization'
            end
            @vcloud_token = response.headers[x_vcloud_authorization]
          end

          @org_name = response.body[:org]
          @user_name = response.body[:user]
        end

        # @note This isn't needed.
        def logout
          delete_logout
          @vcloud_token = nil
          @org_name = nil
        end

        def check_session_matches_credentials(session_org, session_user)
          fog_credential_org = @vcloud_director_username.split('@').last
          fog_credential_user = @vcloud_director_username.split('@')[0...-1].join('@')

          if session_org != fog_credential_org
            raise Fog::Errors::Error.new "FOG_CREDENTIAL specified is for vCloud organisation '#{fog_credential_org}' but " +
              "your current session is for '#{session_org}'. You should generate a new FOG_VCLOUD_TOKEN."
          end

          if session_user != fog_credential_user
            raise Fog::Errors::Error.new "FOG_CREDENTIAL specified is for user '#{fog_credential_user}' but " +
              "your current session is for '#{session_user}'. You should generate a new FOG_VCLOUD_TOKEN."
          end
        end
      end

      class Mock
        attr_reader :end_point, :api_version

        # This is used in some mocks so it's a method rather than a variable
        def default_network_uuid
          @default_network_uuid ||= uuid
        end

        def data
          @@data ||= Hash.new do |hash, key|

            vdc1_uuid = uuid
            vdc2_uuid = uuid
            uplink_network_uuid  = uuid
            isolated_vdc1_network_uuid = uuid
            isolated_vdc2_network_uuid = uuid
            vapp1_id = "vapp-#{uuid}"
            vapp2_id = "vapp-#{uuid}"
            vapp1vm1_id = "vm-#{uuid}"
            vapp2vm1_id = "vm-#{uuid}"
            vapp2vm2_id = "vm-#{uuid}"
            catalog_uuid = uuid
            template_uuid = uuid

            hash[key] = {
              :catalogs => {
                catalog_uuid => {
                  :name => 'Default Catalog'
                }
              },
              :catalog_items => {
                uuid => {
                  :type    => 'vAppTemplate',
                  :name    => 'vAppTemplate 1',
                  :catalog => catalog_uuid,
                  :template_id => template_uuid
                }
              },
              :disks => {
                uuid => {
                  :name => 'Hard Disk 1',
                  :capacity => 10240,
                  :parent_vm => vapp1vm1_id
                }
              },
              :edge_gateways => {
                uuid => {
                  :name => 'MockEdgeGateway',
                  :networks => [uplink_network_uuid, default_network_uuid],
                  :vdc => vdc1_uuid,
                  :Configuration => {
                    :GatewayBackingConfig => "compact",
                    :GatewayInterfaces => {
                      :GatewayInterface => []},
                    :EdgeGatewayServiceConfiguration => {
                      :FirewallService => {
                        :IsEnabled => "true",
                        :DefaultAction => "drop",
                        :LogDefaultAction => "false",
                        :FirewallRule => []
                      },
                      :NatService => {:IsEnabled => "true"}},
                    :HaEnabled => "false",
                    :UseDefaultRouteForDnsRelay => "false"
                  }
                }
              },

              :medias => {},

              :networks => {

                default_network_uuid => {
                  :IsShared => true,
                  :vdc => vdc1_uuid,
                  :FenceMode => 'natRouted',
                  :ApplyRateLimit => "false",
                  :Description => 'Org Network for mocking',
                  :Dns1 => '8.8.8.8',
                  :Dns2 => '8.8.4.4',
                  :DnsSuffix => 'example.com',
                  :Gateway => '192.168.1.1',
                  :InterfaceType => "internal",
                  :IpRanges => [{
                    :StartAddress=>'192.168.1.2',
                    :EndAddress=>'192.168.1.254'
                  }],
                  :IsInherited => false,
                  :Netmask => '255.255.255.0',
                  :name => 'vDC1 Default Network',
                  :SubnetParticipation => {
                      :Gateway => "192.168.1.0",
                      :Netmask => "255.255.0.0",
                      :IpAddress => "192.168.1.0"
                  },
                  :UseForDefaultRoute => "false"
                },

                isolated_vdc1_network_uuid => {
                  :IsShared => false,
                  :vdc => vdc1_uuid,
                  :ApplyRateLimit => "false",
                  :FenceMode => 'isolated',
                  :Description => 'Org Network for mocking',
                  :Dns1 => '8.8.8.8',
                  :Dns2 => '8.8.4.4',
                  :DnsSuffix => 'example.com',
                  :InterfaceType => "internal",
                  :IpRanges => [{
                    :StartAddress=>'10.1.0.100',
                    :EndAddress=>'10.1.0.200'
                  }],
                  :IsInherited => false,
                  :Netmask => '255.255.255.0',
                  :name => 'vDC1 backend network',
                  :SubnetParticipation => {
                      :Gateway => "192.168.1.0",
                      :Netmask => "255.255.0.0",
                      :IpAddress => "192.168.1.0"
                  },
                  :UseForDefaultRoute => "false"
                },

                isolated_vdc2_network_uuid => {
                  :IsShared => false,
                  :vdc => vdc2_uuid,
                  :ApplyRateLimit => "false",
                  :Description => 'Org Network for mocking',
                  :Dns1 => '8.8.8.8',
                  :Dns2 => '8.8.4.4',
                  :DnsSuffix => 'example.com',
                  :InterfaceType => "internal",
                  :IpRanges => [{
                    :StartAddress=>'10.2.0.100',
                    :EndAddress=>'10.2.0.200'
                  }],
                  :IsInherited => false,
                  :Netmask => '255.255.255.0',
                  :name => 'vDC2 backend network',
                  :SubnetParticipation => {
                      :Gateway => "192.168.1.0",
                      :Netmask => "255.255.0.0",
                      :IpAddress => "192.168.1.0"
                  },
                  :UseForDefaultRoute => "false"
                },

                uplink_network_uuid => {
                  :IsShared => false,
                  :vdc => vdc1_uuid,
                  :ApplyRateLimit => "false",
                  :FenceMode => 'bridged',
                  :Description => 'Uplink Network for mocking',
                  :Dns1 => '8.8.8.8',
                  :Dns2 => '8.8.4.4',
                  :DnsSuffix => 'example.com',
                  :Gateway => '198.51.100.1',
                  :InterfaceType => "uplink",
                  :IpRanges => [{
                    :StartAddress=>'198.51.100.2',
                    :EndAddress=>'198.51.100.254'
                  }],
                  :IsInherited => false,
                  :Netmask => '255.255.255.0',
                  :name => 'uplink Network',
                  :SubnetParticipation => {
                    :Gateway => "198.51.100.81",
                    :Netmask => "255.255.255.248",
                    :IpAddress => "198.51.100.83",
                    :IpRanges => {
                      :IpRange => {
                        :StartAddress => "198.51.100.84",
                        :EndAddress => "198.51.100.86"
                      }
                    }
                  },
                  :UseForDefaultRoute => "true"
                }

              },
              :org => {
                :description => 'Organization for mocking',
                :full_name => 'Mock Organization',
                :name => org_name,
                :uuid => uuid
              },

              :tags => {},

              :tasks => {},

              :vapps => {
                vapp1_id => {
                  :name => 'mock-vapp-1',
                  :vdc_id => vdc1_uuid,
                  :description => "Mock vApp 1",
                  :networks => [
                    { :parent_id => default_network_uuid, },
                  ],
                },
                vapp2_id => {
                  :name => 'mock-vapp-2',
                  :vdc_id => vdc2_uuid,
                  :description => "Mock vApp 2",
                  :networks => [
                    { :parent_id => default_network_uuid },
                  ]
                },
              },

              :vdc_storage_classes => {
                uuid => {
                  :default => true,
                  :enabled => true,
                  :limit => 2 * 1024 * 1024,
                  :name => 'DefaultMockStorageClass',
                  :units => 'MB',
                  :vdc => vdc1_uuid,
                }
              },

              :vdcs => {
                vdc1_uuid => {
                  :description => 'vDC1 for mocking',
                  :name => 'MockVDC 1'
                },
                vdc2_uuid => {
                  :description => 'vDC2 for mocking',
                  :name => 'MockVDC 2'
                },
              },

              :vms => {
                vapp1vm1_id => {
                  :name => 'mock-vm-1-1',
                  :parent_vapp => vapp1_id,
                  :nics => [
                    {
                      :network_name => 'Default Network',
                      :mac_address => "00:50:56:aa:bb:01",
                      :ip_address => "192.168.1.33",
                    },
                  ],
                },
                vapp2vm1_id => {
                  :name => 'mock-vm-2-1',
                  :parent_vapp => vapp2_id,
                  :nics => [
                    {
                      :network_name => 'Default Network',
                      :mac_address => "00:50:56:aa:bb:02",
                      :ip_address => "192.168.1.34",
                    },
                  ],
                },
                vapp2vm2_id => {
                  :name => 'mock-vm-2-2',
                  :parent_vapp => vapp2_id,
                  :nics => [
                    {
                      :network_name => 'Default Network',
                      :mac_address => "00:50:56:aa:bb:03",
                      :ip_address => "192.168.1.35",
                    },
                  ],
                },
              },

            }
          end[@vcloud_director_username]
        end

        def initialize(options={})
          @vcloud_director_password = options[:vcloud_director_password]
          @vcloud_director_username = options[:vcloud_director_username]
          #@connection_options = options[:connection_options] || {}
          @host = options[:vcloud_director_host]
          @path = options[:path] || Fog::Compute::VcloudDirector::Defaults::PATH
          @persistent = options[:persistent] || false
          @port = options[:port] || Fog::Compute::VcloudDirector::Defaults::PORT
          @scheme = options[:scheme] || Fog::Compute::VcloudDirector::Defaults::SCHEME
          #@connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
          @end_point    = "#{@scheme}://#{@host}#{@path}/"
          @api_version  = options[:vcloud_director_api_version] || Fog::Compute::VcloudDirector::Defaults::API_VERSION
          @vcloud_token = options[:vcloud_token]
        end

        def vcloud_token
          @vcloud_token || Fog::Mock.random_base64(32)
        end

        def org_name
          @org_name ||=
            begin
              username = @vcloud_director_username.split('@')
              if username.size >= 2 # may be 'email_address@org_name'
                username.last
              else
                Fog::Logger.warning('vcloud_director_username should be in the form user@org_name')
                'vcd_org_name'
              end
            end
        end

        def user_name
          @user_name ||= @vcloud_director_username.split('@').first
        end

        def user_uuid
          @user_uuid ||= uuid
        end

        def uuid
          [8,4,4,4,12].map {|i| Fog::Mock.random_hex(i)}.join('-')
        end

        # Create a task.
        #
        # @param [String] operation A message describing the operation that is
        #   tracked by this task.
        # @param [String] operation_name The short name of the operation that
        #   is tracked by this task.
        # @param [Hash] owner Reference to the owner of the task. This is
        #   typically the object that the task is creating or updating.
        #   * :href<~String> - Contains the URI to the entity.
        #   * :type<~String> - Contains the MIME type of the entity.
        # @return [String] Object identifier of the task.
        def enqueue_task(operation, operation_name, owner, options={})
          task_id = uuid
          now = DateTime.now

          data[:tasks][task_id] = {
            :cancel_requested => false,
            :details => '',
            :expiry_time => now + 86400, # in 24 hours
            :name => 'task',
            :progress => 1,
            :service_namespace => 'com.vmware.vcloud',
            :start_time => now,
            :end_time => now + 86400,
            :status => 'running',
          }.merge(options).merge(
            :operation => operation,
            :operation_name => operation_name,
            :owner => owner
          )

          task_id
        end

        # @note As far as this method is concerned, the only possible task
        #   states are 'running' and 'success'.
        #
        # @param [Hash] response_body
        # @return [Boolean]
        def process_task(response_body)
          task_id = response_body[:href].split('/').last
          task = data[:tasks][task_id]

          if task[:status] == 'running'
            task[:end_time] = DateTime.now
            task[:progress] = 100
            task[:status] = 'success'

            if task[:on_success]
              task[:on_success].call
              task.delete(:on_success)
            end
          end

          return true if task[:status] == 'success'
          raise TaskError.new "status: #{task[:status]}, error: #{task[:Error]}"
        end

        def add_id_from_href!(data={})
          data[:id] = data[:href].split('/').last
        end

        private

        def make_href(path)
          "#{@end_point}#{path}"
        end

        def xmlns
          'http://www.vmware.com/vcloud/v1.5'
        end

        def xmlns_xsi
          'http://www.w3.org/2001/XMLSchema-instance'
        end

        def xsi_schema_location
          "http://www.vmware.com/vcloud/v1.5 http://#{@host}#{@path}/v1.5/schema/master.xsd"
        end
      end
    end
  end
end
