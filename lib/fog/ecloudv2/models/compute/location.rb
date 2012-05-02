module Fog
  module Compute
    class Ecloudv2
      class Location < Fog::Ecloud::Model

        identity :href

        ignore_attributes :xmlns, :xmlns_xsi, :xmlns_xsd, :xmlns_i

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type

      end
    end
  end
end
