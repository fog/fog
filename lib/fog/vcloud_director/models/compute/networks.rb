require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/network'

module Fog
  module Compute
    class VcloudDirector
      class Networks < Collection

        include Fog::VcloudDirector::Query

        model Fog::Compute::VcloudDirector::Network

        attribute :organization
        attribute :vdc

        def query_type
          "orgVdcNetwork"
        end

        private

        def get_by_id(item_id)
          raw_network = service.get_network_complete(item_id).body
          data = {}
          data[:type] = raw_network[:type]
          data[:href] = raw_network[:href]
          service.add_id_from_href!(data)
          data[:name] = raw_network[:name]
          data[:description] = raw_network[:Description]
          data[:is_shared] = raw_network[:IsShared]
          net_config = raw_network[:Configuration]
          data[:fence_mode] = net_config[:FenceMode]
          ip_scope = net_config[:IpScopes][:IpScope]
          data[:is_inherited] = ip_scope[:IsInherited]
          data[:gateway] = ip_scope[:Gateway]
          data[:netmask] = ip_scope[:Netmask]
          data[:dns1] = ip_scope[:Dns1]
          data[:dns2] = ip_scope[:Dns2]
          data[:dns_suffix] = ip_scope[:DnsSuffix]
          data[:ip_ranges] = []
          raw_ip_ranges = ip_scope[:IpRanges][:IpRange]
          data[:ip_ranges] = raw_ip_ranges.map do |ip_range|
            { :start_address => ip_range[:StartAddress],
              :end_address   => ip_range[:EndAddress] }
          end
          data
        end

        def item_list
          items = if vdc
            vdc.available_networks.select {|link| link[:type] == "application/vnd.vmware.vcloud.network+xml"}
          else
            data = service.get_organization(organization.id).body
            data[:Link].select { |link| link[:type] == "application/vnd.vmware.vcloud.orgNetwork+xml" }
          end
          items.each{|item| service.add_id_from_href!(item) }
          items
        end
      end
    end
  end
end
