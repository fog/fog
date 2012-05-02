module Fog
  module Compute
    class Ecloudv2
      class Organization < Fog::Ecloud::Model

        identity :href

        ignore_attributes :xmlns, :xmlns_xsi, :xmlns_xsd, :xmlns_i

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links

        def locations
          @locations ||= Fog::Compute::Ecloudv2::Locations.new( :connection => connection, :href => href )
        end

        def environments 
          @environments ||= Fog::Compute::Ecloudv2::Environments.new(:connection => connection, :href => href)
        end

        alias :vdcs :environments
      end
    end
  end
end
