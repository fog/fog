module Fog
  module Compute
    class Ecloud
      class Network < Fog::Ecloud::Model
        identity :href

        attribute :name,              :aliases => :Name
        attribute :type,              :aliases => :Type
        attribute :other_links,       :aliases => :Links, :squash => :Link
        attribute :address,           :aliases => :Address
        attribute :network_type,      :aliases => :NetworkType
        attribute :broadcast_address, :aliases => :BroadcastAddress
        attribute :gateway_address,   :aliases => :GatewayAddress
        attribute :rnat_address,      :aliases => :RnatAddress

        def rnats
          @rnats ||= Fog::Compute::Ecloud::Rnats.new(:service => service, :href => "#{service.base_path}/rnats/networks/#{id}")
        end

        def ips
          @ips ||= Fog::Compute::Ecloud::IpAddresses.new(:service => service, :href => href)
        end

        def edit_rnat_association(options)
          options[:uri] = href
          data = service.rnat_associations_edit_network(options).body
          task = Fog::Compute::Ecloud::Tasks.new(:service => service, :href => data[:href])[0]
        end

        def id
          href.scan(/\d+/)[0]
        end

        def environment
          reload if other_links.nil?
          environment_href = other_links.find { |l| l[:type] == "application/vnd.tmrk.cloud.environment" }[:href]
          self.service.environments.get(environment_href)
        end

        def location
          environment.id
        end
      end
    end
  end
end
