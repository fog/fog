module Fog
  module Compute
    class Ecloudv2
      class IpAddress < Fog::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :host, :aliases => :Host
        attribute :detected_on, :aliases => :DetectedOn
        attribute :rnat_address, :aliases => :RnatAddress
        attribute :reserved, :aliases => :Reserved, :type => :boolean

        
        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
