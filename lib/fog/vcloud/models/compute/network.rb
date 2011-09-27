module Fog
  module Vcloud
    class Compute
      class Network < Fog::Vcloud::Model

        identity :href

        ignore_attributes :xmlns, :xmlns_xsi, :xmlns_xsd, :xmlns_i, :Id

        attribute :name, :aliases => :Name
        #attribute :id, :aliases => :Id

        attribute :description
        attribute :configuration, :aliases => :Configuration

        attribute :links, :aliases => :Link, :type => :array

      end
    end
  end
end
