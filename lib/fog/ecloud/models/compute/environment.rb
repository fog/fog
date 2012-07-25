module Fog
  module Compute
    class Ecloud
      class Environment < Fog::Ecloud::Model

        identity :href

        ignore_attributes :xmlns, :xmlns_xsi, :xmlns_xsd

        attribute :name
        attribute :type
        attribute :other_links, :aliases => :Links

        def public_ips
          @public_ips ||= Fog::Compute::Ecloud::PublicIps.new(:connection => connection, :href => "/cloudapi/ecloud/publicIps/environments/#{id}")
        end

        def internet_services
          @internet_services ||= Fog::Compute::Ecloud::InternetServices.new(:connection => connection, :href => "/cloudapi/ecloud/networkSummary/environments/#{id}")
        end

        def node_services
          @node_services ||= Fog::Compute::Ecloud::Nodes.new(:connection => connection, :href => "/cloudapi/ecloud/networkSummary/environments/#{id}")
        end

        def backup_internet_services
          @backup_internet_services ||= Fog::Compute::Ecloud::BackupInternetServices.new(:connection, :href => "/cloudapi/ecloud/backupInternetServices/environments/#{id}")
        end

        def networks
          @networks ||= Fog::Compute::Ecloud::Networks.new(:connection => connection, :href => "/cloudapi/ecloud/networks/environments/#{id}")
        end

        def servers
          @servers = nil
          pools = compute_pools
          pools.each do |c|
            if pools.index(c) == 0
              @servers = c.servers
            else
              c.servers.each { |s| @servers << s }
            end
          end
          @servers
        end

        def layout
          @layout ||= Fog::Compute::Ecloud::Layouts.new(:connection => connection, :href => "/cloudapi/ecloud/layout/environments/#{id}").first
        end

        def rows
          layout.rows
        end

        def tasks
          @tasks ||= Fog::Compute::Ecloud::Tasks.new(:connection => connection, :href => "/cloudapi/ecloud/tasks/environments/#{id}")
        end

        def firewall_acls
          @firewall_acls ||= Fog::Compute::Ecloud::FirewallAcls.new(:connection => connection, :href => "/cloudapi/ecloud/firewallAcls/environments/#{id}")
        end

        def compute_pools
          @compute_pools ||= Fog::Compute::Ecloud::ComputePools.new(:connection => connection, :href => "/cloudapi/ecloud/computePools/environments/#{id}")
        end

        def physical_devices
          @physical_devices ||= Fog::Compute::Ecloud::PhysicalDevices.new(:connection => connection, :href => "/cloudapi/ecloud/physicalDevices/environments/#{id}")
        end

        def trusted_network_groups
          @trusted_network_groups ||= Fog::Compute::Ecloud::TrustedNetworkGroups.new(:connection => connection, :href => "/cloudapi/ecloud/trustedNetworkGroups/environments/#{id}")
        end

        def catalog
          org_href = other_links[:Link].detect { |l| l[:type] == "application/vnd.tmrk.cloud.organization" }[:href]
          @catalog ||= Fog::Compute::Ecloud::Catalog.new(:connection => connection, :href => "/cloudapi/ecloud/admin/catalog/organizations/#{org_href.scan(/\d+/)[0]}")
        end

        def rnats
          @rnats ||= Fog::Compute::Ecloud::Rnats.new(:connection => connection, :href => "/cloudapi/ecloud/rnats/environments/#{id}")
        end

        def create_trusted_network_group(options = {})
          options[:uri] = "/cloudapi/ecloud/trustedNetworkGroups/environments/#{id}/action/createTrustedNetworkGroup"
          data = connection.trusted_network_groups_create(options).body
          tng = Fog::Compute::Ecloud::TrustedNetworkGroups.new(:connection => connection, :href => data[:href])[0]
        end

        def create_firewall_acl(options = {})
          options[:uri] = "/cloudapi/ecloud/firewallAcls/environments/#{id}/action/createFirewallAcl"
          options[:permission] ||= "deny"
          options[:protocol] ||= "any"
          data = connection.firewall_acls_create(options).body
          acl = Fog::Compute::Ecloud::FirewallAcls.new(:connection => connection, :href => data[:href])[0]
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
      Vdc = Environment
    end
  end
end
