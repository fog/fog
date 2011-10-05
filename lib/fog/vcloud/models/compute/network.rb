module Fog
  module Vcloud
    class Compute
      class Network < Fog::Vcloud::Model

        identity :href, :aliases => :Href

        ignore_attributes :xmlns, :xmlns_xsi, :xmlns_xsd, :xmlns_i, :Id

        attribute :name, :aliases => :Name

        attribute :description, :aliases => :Description
        attribute :configuration, :aliases => :Configuration

        attribute :links, :aliases => :Link, :type => :array

      end
    end
  end
end
