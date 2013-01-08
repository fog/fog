module Fog
  module Compute
    class Ecloud
      class Rnat < Fog::Ecloud::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :default, :aliases => :Default, :type => :boolean
        attribute :public_ip, :aliases => :PublicIp

        def networks
          @networks = Fog::Compute::Ecloud::Networks.new(:service => service, :href => href)
        end

        def associations
          @associations = Fog::Compute::Ecloud::Associations.new(:service => service, :href => href)
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
