require 'fog/core/collection'
require 'fog/openstack/models/baremetal/node'

module Fog
  module Baremetal
    class OpenStack
      class Nodes < Fog::Collection
        model Fog::Baremetal::OpenStack::Node

        def all
          load(service.list_nodes.body['nodes'])
        end

        def details(parameters=nil)
          load(service.list_nodes_detailed(parameters).body['nodes'])
        end

        def find_by_uuid(uuid)
          new(service.get_node(uuid).body)
        end
        alias_method :get, :find_by_uuid

        def destroy(uuid)
          node = self.find_by_id(uuid)
          node.destroy
        end

        def method_missing(method_sym, *arguments, &block)
          if method_sym.to_s =~ /^find_by_(.*)$/
            load(service.list_nodes_detailed({$1 => arguments.first}).body['nodes'])
          else
            super
          end
        end
      end
    end
  end
end
