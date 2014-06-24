require 'fog/core/collection'
require 'fog/openstack/models/identity/service'

module Fog
  module Identity
    class OpenStack
      class Services < Fog::Collection
        model Fog::Identity::OpenStack::Service

        def all
          load(service.list_services.body['OS-KSADM:services'])
        end

        def find_by_id(id)
          cached_service = self.find {|serv| serv.id == id}
          return cached_service if cached_service
          service_hash = service.get_service(id).body['OS-KSADM:service']
          Fog::Identity::OpenStack::Service.new(
            service_hash.merge(:service => service))
        end

        def destroy(id)
          serv = self.find_by_id(id)
          serv.destroy
        end
      end # class Services
    end # class OpenStack
  end # module Compute
end # module Fog
