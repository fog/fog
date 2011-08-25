require 'fog/ecloud/models/compute/node'

module Fog
  module Compute
    class Ecloud

      class Nodes < Fog::Ecloud::Collection

        model Fog::Compute::Ecloud::Node

        attribute :href, :aliases => :Href

        def all
          check_href!( :messages => "the Nodes href of the Internet Service you want to enumerate" )
          if data = connection.get_nodes(href).body[:NodeService]
            load(data)
          end
        end

        def get(uri)
          if data = connection.get_node(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end
    end
  end
end
