require 'fog/vcloud/models/compute/network'

module Fog
  module Vcloud
    class Compute
      class Networks < Fog::Vcloud::Collection
        undef_method :create

        model Fog::Vcloud::Compute::Network

        attribute :href

        def all
          self.href = service.default_vdc_href unless self.href
          data = nil
          if self.href =~ /\/vdc\//
            check_href!("Vdc")
            data = [service.get_vdc(self.href).available_networks].flatten.compact.reject{|n| n == '' }
          elsif self.href =~ /\/org\//
            check_href!("Org")
            data = service.get_organization(self.href).links.select{|l| l[:type] == network_type_id }
          elsif self.href =~ /\/vApp\//
            check_href!("Vapp")
            data = [(service.get_vapp(self.href).network_configs||{})[:NetworkConfig]].flatten.compact.map{|n| n[:Configuration][:ParentNetwork] unless n[:Configuration].nil? }.compact
          end
          load([*data]) unless data.nil?
        end

        def get(uri)
          service.get_network(uri)
        rescue Fog::Errors::NotFound
          nil
        end

        private
        def network_type_id
          if service.version == '1.0'
            'application/vnd.vmware.vcloud.network+xml'
          else
            'application/vnd.vmware.vcloud.orgNetwork+xml'
          end
        end
      end
    end
  end
end
