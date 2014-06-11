module Fog
  module Compute
    class Ecloud
      class IpAddress < Fog::Ecloud::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links, :squash => :Link
        attribute :host, :aliases => :Host
        attribute :detected_on, :aliases => :DetectedOn
        attribute :rnat, :aliases => :RnatAddress
        attribute :reserved, :aliases => :Reserved, :type => :boolean

        def status
          (detected_on || host) ? "Assigned" : "Available"
        end

        def id
          href.match(/((\d+{1,3}\.){3}(\d+{1,3}))$/)[1]
        end

        def server
          @server ||= begin
                        reload unless other_links
                        server_link = other_links.find{|l| l[:type] == "application/vnd.tmrk.cloud.virtualMachine"}
                        self.service.servers.get(server_link[:href])
                      end
        end

        def network
          reload if other_links.nil?
          network_href = other_links.find { |l| l[:type] == "application/vnd.tmrk.cloud.network" }[:href]
          network      = self.service.networks.get(network_href)
        end
      end
    end
  end
end
