module Fog
  module Compute
    class Ecloud
      class IpAddress < Fog::Ecloud::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :host, :aliases => :Host
        attribute :detected_on, :aliases => :DetectedOn
        attribute :rnat, :aliases => :RnatAddress
        attribute :reserved, :aliases => :Reserved, :type => :boolean

        def status
          (detected_on || host) ? "Assigned" : "Available"
        end
        
        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
