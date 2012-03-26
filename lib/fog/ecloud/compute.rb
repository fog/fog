require File.expand_path(File.join(File.dirname(__FILE__), '..', 'ecloud'))
require 'ipaddr'

class IPAddr
  def mask
    _to_string(@mask_addr)
  end
end

module Fog
  module Ecloud
    class Collection < Fog::Collection

      def load(objects)
        objects = [ objects ] if objects.is_a?(Hash)
        super
      end

      def check_href!(opts = {})
        unless href
          opts = { :parent => opts } if opts.is_a?(String)
          msg = ":href missing, call with a :href pointing to #{if opts[:message]
                  opts[:message]
                elsif opts[:parent]
                  "the #{opts[:parent]} whos #{self.class.to_s.split('::').last.downcase} you want to enumerate"
                else
                  "the resource"
                end}"
          raise Fog::Errors::Error.new(msg)
        end
      end

    end
  end
end

module Fog
  module Ecloud
    module MockDataClasses
      class Base < Hash
        def self.base_url=(url)
          @base_url = url
        end

        self.base_url = "http://vcloud.example.com"

        def self.base_url
          @base_url
        end

        def first
          raise "Don't do this"
        end

        def last
          raise "Don't do this"
        end

        def initialize(data = {}, parent = nil)
          @parent = parent

          replace(data)
        end

        def _parent
          @parent
        end

        def base_url
          Base.base_url
        end

        def href
          [base_url, self.class.name.split("::").last, object_id].join("/")
        end

        def inspect
          "<#{self.class.name} #{object_id} data=#{super}>"
        end
      end

      class MockData < Base
        def versions
          @versions ||= []
        end

        def organizations
          @organizations ||= []
        end

        def organization_from_href(href)
          find_href_in(href, organizations)
        end

        def all_vdcs
          organizations.map(&:vdcs).flatten
        end

        def vdc_from_href(href)
          find_href_in(href, all_vdcs)
        end

        def all_catalogs
          all_vdcs.map(&:catalog).flatten
        end

        def catalog_from_href(href)
          find_href_in(href, all_catalogs)
        end

        def all_catalog_items
          all_catalogs.map(&:items).flatten
        end

        def catalog_item_from_href(href)
          find_href_in(href, all_catalog_items)
        end

        def all_virtual_machines
          all_vdcs.map(&:virtual_machines).flatten
        end

        def virtual_machine_from_href(href)
          find_href_prefixed_in(href, all_virtual_machines)
        end


        def all_networks
          all_vdcs.map(&:networks).flatten
        end

        def network_from_href(href)
          find_href_in(href, all_networks)
        end

        def all_network_extensions
          all_networks.map(&:extensions).flatten
        end

        def network_extension_from_href(href)
          find_href_in(href, all_network_extensions)
        end

        def all_vdc_internet_service_collections
          all_vdcs.map(&:internet_service_collection).flatten
        end

        def vdc_internet_service_collection_from_href(href)
          find_href_in(href, all_vdc_internet_service_collections)
        end

        def all_backup_internet_services
          all_vdc_internet_service_collections.map(&:backup_internet_services).flatten
        end

        def backup_internet_service_from_href(href)
          find_href_in(href, all_backup_internet_services)
        end

        def all_public_ip_collections
          all_vdcs.map {|v| v.public_ip_collection }.flatten
        end

        def public_ip_collection_from_href(href)
          find_href_in(href, all_public_ip_collections)
        end

        def all_public_ips
          all_public_ip_collections.map(&:items).flatten
        end

        def public_ip_from_href(href)
          find_href_in(href, all_public_ips)
        end

        def all_public_ip_internet_service_collections
          all_public_ips.map(&:internet_service_collection).flatten
        end

        def public_ip_internet_service_collection_from_href(href)
          find_href_in(href, all_public_ip_internet_service_collections)
        end

        def all_public_ip_internet_services
          all_public_ip_internet_service_collections.map(&:items).flatten
        end

        def public_ip_internet_service_from_href(href)
          find_href_in(href, all_public_ip_internet_services)
        end

        def all_public_ip_internet_service_node_collections
          all_public_ip_internet_services.map(&:node_collection).flatten
        end

        def public_ip_internet_service_node_collection_from_href(href)
          find_href_in(href, all_public_ip_internet_service_node_collections)
        end

        def all_public_ip_internet_service_nodes
          all_public_ip_internet_service_node_collections.map(&:items).flatten
        end

        def public_ip_internet_service_node_from_href(href)
          find_href_in(href, all_public_ip_internet_service_nodes)
        end

        def all_network_ip_collections
          all_networks.map(&:ip_collection)
        end

        def network_ip_collection_from_href(href)
          find_href_in(href, all_network_ip_collections)
        end

        def all_network_ips
          all_network_ip_collections.map {|c| c.items.values }.flatten
        end

        def network_ip_from_href(href)
          find_href_in(href, all_network_ips)
        end

        private

        def find_href_in(href, objects)
          objects.detect {|o| o.href == href }
        end

        def find_href_prefixed_in(href, objects)
          objects.detect {|o| href =~ %r{^#{o.href}($|/)} }
        end
      end

      class MockVersion < Base
        def version
          self[:version]
        end

        def supported
          !!self[:supported]
        end

        def login_url
          href
        end
      end

      class MockOrganization < Base
        def name
          self[:name]
        end

        def vdcs
          @vdcs ||= []
        end
      end

      class MockVdc < Base
        def name
          self[:name]
        end

        def storage_allocated
          self[:storage_allocated] || 200
        end

        def storage_used
          self[:storage_used] || 105
        end

        def cpu_allocated
          self[:cpu_allocated] || 10000
        end

        def memory_allocated
          self[:memory_allocated] || 20480
        end

        def catalog
          @catalog ||= MockCatalog.new({}, self)
        end

        def networks
          @networks ||= []
        end

        def virtual_machines
          @virtual_machines ||= []
        end

        def task_list
          @task_list ||= MockTaskList.new({}, self)
        end

        # for TM eCloud, should probably be subclassed
        def public_ip_collection
          @public_ip_collection ||= MockPublicIps.new({}, self)
        end

        def internet_service_collection
          @internet_service_collection ||= MockVdcInternetServices.new({}, self)
        end

        def firewall_acls
          @firewall_acls ||= MockFirewallAcls.new({}, self)
        end
      end

      class MockTaskList < Base
        def name
          self[:name] || "Tasks List"
        end
      end

      class MockCatalog < Base
        def name
          self[:name] || "Catalog"
        end

        def items
          @items ||= []
        end
      end

      class MockCatalogItem < Base
        def name
          self[:name]
        end

        def disks
          @disks ||= MockVirtualMachineDisks.new(self)
        end

        def customization
          @customization ||= MockCatalogItemCustomization.new({}, self)
        end

        def vapp_template
          @vapp_template ||= MockCatalogItemVappTemplate.new({ :name => name }, self)
        end
      end

      class MockCatalogItemCustomization < Base
        def name
          self[:name] || "Customization Options"
        end
      end

      class MockCatalogItemVappTemplate < Base
        def name
          self[:name]
        end
      end

      class MockNetwork < Base
        def name
          self[:name] || subnet
        end

        def subnet
          self[:subnet]
        end

        def gateway
          self[:gateway] || subnet_ips[1]
        end

        def netmask
          self[:netmask] || subnet_ipaddr.mask
        end

        def dns
          "8.8.8.8"
        end

        def features
          [
           { :type => :FenceMode, :value => "isolated" }
          ]
        end

        def ip_collection
          @ip_collection ||= MockNetworkIps.new({}, self)
        end

        def extensions
          @extensions ||= MockNetworkExtensions.new({}, self)
        end

        def random_ip
          usable_subnet_ips[rand(usable_subnet_ips.length)]
        end

        # for TM eCloud. should probably be a subclass
        def rnat
          self[:rnat]
        end

        def usable_subnet_ips
          subnet_ips[3..-2]
        end

        def address
          subnet_ips.first
        end

        def broadcast
          subnet_ips.last
        end

        private

        def subnet_ipaddr
          @ipaddr ||= IPAddr.new(subnet)
        end

        def subnet_ips
          subnet_ipaddr.to_range.to_a.map(&:to_s)
        end
      end

      class MockNetworkIps < Base
        def items
          @items ||= _parent.usable_subnet_ips.inject({}) do |out, subnet_ip|
            out.update(subnet_ip => MockNetworkIp.new({ :ip => subnet_ip }, self))
          end
        end

        def ordered_ips
          items.values.sort_by {|i| i.ip.split(".").map(&:to_i) }
        end

        def name
          "IP Addresses"
        end
      end

      class MockNetworkIp < Base
        def name
          self[:name] || ip
        end

        def ip
          self[:ip]
        end

        def used_by
          self[:used_by] || _parent._parent._parent.virtual_machines.detect {|v| v.ip == ip }
        end

        def status
          if used_by
            "Assigned"
          else
            "Available"
          end
        end

        def rnat
          self[:rnat] || _parent._parent.rnat
        end

        def rnat_set?
          !!self[:rnat]
        end
      end

      class MockNetworkExtensions < Base
        def name
          _parent.name
        end

        def gateway
          _parent.gateway
        end

        def broadcast
          _parent.broadcast
        end

        def address
          _parent.address
        end

        def rnat
          _parent.rnat
        end

        def type
          self[:type] || "DMZ"
        end

        def vlan
          object_id.to_s
        end

        def friendly_name
          "#{name} (#{type}_#{object_id})"
        end
      end

      class MockVirtualMachine < Base
        def name
          self[:name]
        end

        def ip
          self[:ip]
        end

        def cpus
          self[:cpus] || 1
        end

        def memory
          self[:memory] || 1024
        end

        def disks
          @disks ||= MockVirtualMachineDisks.new(self)
        end

        def status
          self[:status] || 2
        end

        def power_off!
          self[:status] = 2
        end

        def power_on!
          self[:status] = 4
        end

        def size
          disks.inject(0) {|s, d| s + d.vcloud_size }
        end

        def network_ip
          if network = _parent.networks.detect {|n| n.ip_collection.items[ip] }
            network.ip_collection.items[ip]
          end
        end

        # from fog ecloud server's _compose_vapp_data
        def to_configure_vapp_hash
          {
            :name   => name,
            :cpus   => cpus,
            :memory => memory,
            :disks  => disks.map {|d| { :number => d.address.to_s, :size => d.vcloud_size, :resource => d.vcloud_size.to_s } }
          }
        end

        def href(purpose = :base)
          case purpose
          when :base
            super()
          when :power_on
            super() + "/power/action/powerOn"
          when :power_off
            super() + "/power/action/powerOff"
          end
        end
      end

      class MockVirtualMachineDisks < Array
        def initialize(parent = nil)
          @parent = parent
        end

        def _parent
          @parent
        end

        def <<(disk)
          next_address = 0
          disk_with_max_address = max {|a, b| a[:address] <=> b[:address] }
          disk_with_max_address && next_address = disk_with_max_address.address + 1
          disk[:address] ||= next_address

          super(disk)

          if (addresses = map {|d| d.address }).uniq.size != size
            raise "Duplicate disk address in: #{addresses.inspect} (#{size})"
          end

          sort! {|a, b| a.address <=> b.address }
          self
        end

        def at_address(address)
          detect {|d| d.address == address }
        end
      end

      class MockVirtualMachineDisk < Base
        def size
          self[:size].to_i
        end

        def vcloud_size
          # kilobytes
          size * 1024
        end

        def address
          self[:address].to_i
        end
      end

      # for Terremark eCloud

      class MockVdcInternetServices < Base
        def href
          _parent.href + "/internetServices"
        end

        def name
          "Internet Services"
        end

        def items
          public_ip_internet_services + backup_internet_services
        end

        def public_ip_internet_services
          _parent.public_ip_collection.items.inject([]) do |services, public_ip|
            services + public_ip.internet_service_collection.items
          end
        end

        def backup_internet_services
          @backup_internet_services ||= []
        end
      end

      class MockBackupInternetService < Base
        def name
          self[:name] || "Backup Internet Service #{object_id}"
        end

        def protocol
          self[:protocol]
        end

        def port
          0
        end

        def enabled
          self[:enabled].to_s.downcase != "false"
        end

        def timeout
          self[:timeout] || 2
        end

        def description
          self[:description] || "Description for Backup Service #{name}"
        end

        def redirect_url
          nil
        end

        def node_collection
          @node_collection ||= MockPublicIpInternetServiceNodes.new({}, self)
        end
      end

      class MockFirewallAcls < Base
        def name
          "Firewall Access List"
        end
      end

      class MockPublicIps < Base
        def name
          self[:name] || "Public IPs"
        end

        def items
          @items ||= []
        end
      end

      class MockPublicIp < Base
        def name
          self[:name]
        end

        def internet_service_collection
          @internet_service_collection ||= MockPublicIpInternetServices.new({}, self)
        end
      end

      class MockPublicIpInternetServices < Base
        def href
          _parent.href + "/internetServices"
        end

        def items
          @items ||= []
        end
      end

      class MockPublicIpInternetService < Base
        def name
          self[:name] || "Public IP Service #{object_id}"
        end

        def description
          self[:description] || "Description for Public IP Service #{name}"
        end

        def protocol
          self[:protocol]
        end

        def port
          self[:port]
        end

        def enabled
          !!self[:enabled]
        end

        def redirect_url
          self[:redirect_url]
        end

        def timeout
          self[:timeout] || 2
        end

        def node_collection
          @node_collection ||= MockPublicIpInternetServiceNodes.new({}, self)
        end

        def monitor
          nil
        end

        def backup_service
          self[:backup_service]
        end
      end

      class MockPublicIpInternetServiceNodes < Base
        def href
          _parent.href + "/nodeServices"
        end

        def items
          @items ||= [].tap do |node_array|
            node_array.instance_variable_set("@default_port", _parent.port)

            def node_array.<<(node)
              node[:port] ||= @default_port
              super
            end
          end
        end
      end

      class MockPublicIpInternetServiceNode < Base
        def ip_address
          self[:ip_address]
        end

        def name
          self[:name] || "Public IP Service Node #{object_id}"
        end

        def description
          self[:description] || "Description for Public IP Service Node #{name}"
        end

        def port
          self[:port]
        end

        def enabled
          self[:enabled].to_s.downcase != "false"
        end

        def enabled=(new_value)
          self[:enabled] = new_value
        end
      end
    end
  end
end


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

      class UnsupportedVersion < Exception ; end

      requires   :ecloud_username, :ecloud_password, :ecloud_versions_uri
      recognizes :ecloud_version

      model_path 'fog/ecloud/models/compute'
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

      request_path 'fog/ecloud/requests/compute'
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
        include Fog::Ecloud::MockDataClasses

        def self.base_url
          "https://fakey.com/api/v0.8b-ext2.6"
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

        def self.reset
          @mock_data = nil
        end

        def self.data_reset
          Fog::Logger.deprecation("#{self} => #data_reset is deprecated, use #reset instead [light_black](#{caller.first})[/]")
          self.reset
        end

        def initialize(options = {})
          require 'builder'
          require 'fog/core/parser'

          @versions_uri = URI.parse('https://vcloud.fakey.com/api/versions')
        end

        def mock_data
          Fog::Compute::Ecloud::Mock.data
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
          require 'builder'
          require 'fog/core/parser'

          @connections = {}
          @connection_options = options[:connection_options] || {}
          @versions_uri = URI.parse(options[:ecloud_versions_uri])
          @version    = options[:ecloud_version]
          @username   = options[:ecloud_username]
          @password   = options[:ecloud_password]
          @persistent = options[:persistent] || false
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
          ["v0.8b-ext2.6", "0.8b-ext2.6", "v0.8b-ext2.8" , "0.8b-ext2.8"]
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
          host_url = "#{params[:uri].scheme}://#{params[:uri].host}#{params[:uri].port ? ":#{params[:uri].port}" : ''}"

          # Hash connections on the host_url ... There's nothing to say we won't get URI's that go to
          # different hosts.
          @connections[host_url] ||= Fog::Connection.new(host_url, @persistent, @connection_options)

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
