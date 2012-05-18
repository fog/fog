module Fog
  module Compute
    class Ecloudv2
      class Rnat < Fog::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :default, :aliases => :Default, :type => :boolean
        attribute :public_ip, :aliases => :PublicIp

        def networks
          @networks = Fog::Compute::Ecloudv2::Networks.new(:connection => connection, :href => href)
        end

        def associations
          @associations = Fog::Compute::Ecloudv2::Associations.new(:connection => connection, :href => href)
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
