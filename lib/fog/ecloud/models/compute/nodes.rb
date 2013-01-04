require 'fog/ecloud/models/compute/node'

module Fog
  module Compute
    class Ecloud
      class Nodes < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::Node

        def all
          data = connection.get_nodes(href).body
          if data[:NodeServices]
            load(data[:NodeServices][:NodeService])
          else
            load([])
          end
        end

        def get(uri)
          data = connection.get_node(uri).body
          if data == ""
            new({})
          else
            new(data)
          end
        rescue Fog::Errors::NotFound
          nil
        end

        def create(options)
          options[:uri] = "/cloudapi/ecloud/nodeServices/internetServices/#{internet_service_id}/action/createNodeService"
          options[:protocol] ||= "TCP"
          options[:enabled] ||= true
          options[:description] ||= ""
          data = connection.node_service_create(options).body
          object = new(data)
        end

        def internet_service_id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
