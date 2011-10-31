require 'fog/vcloud/models/compute/network'

module Fog
  module Vcloud
    class Compute

      class Networks < Fog::Vcloud::Collection

        undef_method :create

        model Fog::Vcloud::Compute::Network

        attribute :href

        def all
          self.href = connection.default_vdc_href unless self.href
          data = nil
          if self.href =~ /\/vdc\//
            check_href!("Vdc")
            data = [connection.get_vdc(self.href).body[:AvailableNetworks][:Network]].flatten.compact
          elsif self.href =~ /\/org\//
            check_href!("Org")
            links = (l=connection.get_organization(self.href).body[:Link]).is_a?(Array) ? l : [l].compact
            data = links.select{|l| l[:type] == 'application/vnd.vmware.vcloud.network+xml' }
          elsif self.href =~ /\/vApp\//
            check_href!("Vapp")
            data = [(connection.get_vapp(self.href).body[:NetworkConfigSection]||{})[:NetworkConfig]].flatten.compact.collect{|n| n[:Configuration][:ParentNetwork] unless n[:Configuration].nil? }.compact
          end
          load([*data]) unless data.nil?
        end

        def get(uri)
          if data = connection.get_network(uri)
            new(data.body)
          end
          rescue Fog::Errors::NotFound
          nil
        end

      end
    end
  end
end
