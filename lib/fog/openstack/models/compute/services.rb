require 'fog/core/collection'
require 'fog/openstack/models/compute/service'

module Fog
  module Compute
    class OpenStack
      class Services < Fog::Collection
        model Fog::Compute::OpenStack::Service

        def all(options = {})
          load(service.list_services(options).body['services'])
        end

        alias_method :summary, :all

        def details(options = {})
          Fog::Logger.deprecation('Calling OpenStack[:compute].services.details is deprecated, use .services.all')
          load(service.list_services(options).body['services'])
        end
      end
    end
  end
end
