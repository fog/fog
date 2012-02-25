module Fog
  module Vcloud
    class Compute
      class Network < Fog::Vcloud::Model

        identity :href, :aliases => :Href
        attribute :links, :aliases => :Link, :type => :array
        ignore_attributes :xmlns, :xmlns_i, :xmlns_xsi, :xmlns_xsd

        attribute :name, :aliases => :Name

        attribute :description, :aliases => :Description
        attribute :configuration, :aliases => :Configuration
        attribute :provider_info, :aliases => :ProviderInfo

        def parent_network
          return nil if configuration[:ParentNetwork].nil?
          @parent_network ||= connection.get_network(configuration[:ParentNetwork][:href])
        end
      end
    end
  end
end
