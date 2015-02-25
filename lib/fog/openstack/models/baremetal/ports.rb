require 'fog/core/collection'
require 'fog/openstack/models/baremetal/port'

module Fog
  module Baremetal
    class OpenStack
      class Ports < Fog::Collection
        model Fog::Baremetal::OpenStack::Port

        def all
          load(service.list_ports.body['ports'])
        end

        def details(parameters=nil)
          load(service.list_ports_detailed(parameters).body['ports'])
        end

        def find_by_uuid(uuid)
          new(service.get_port(uuid).body)
        end
        alias_method :get, :find_by_uuid

        def destroy(uuid)
          port = self.find_by_id(uuid)
          port.destroy
        end

        def method_missing(method_sym, *arguments, &block)
          if method_sym.to_s =~ /^find_by_(.*)$/
            load(service.list_ports_detailed({$1 => arguments.first}).body['ports'])
          else
            super
          end
        end
      end
    end
  end
end
