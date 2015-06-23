require 'fog/core/collection'
require 'fog/openstack/models/baremetal/driver'

module Fog
  module Baremetal
    class OpenStack
      class Drivers < Fog::Collection
        model Fog::Baremetal::OpenStack::Driver

        def all(options = {})
          load(service.list_drivers(options).body['drivers'])
        end

        alias_method :summary, :all

        def find_by_name(name)
          new(service.get_driver(name).body)
        end
        alias_method :get, :find_by_name
      end
    end
  end
end
