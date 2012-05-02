module Fog
  module Compute
    class Ecloudv2
      class PublicIp < Fog::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :ip_type, :aliases => :IpType

        
        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
