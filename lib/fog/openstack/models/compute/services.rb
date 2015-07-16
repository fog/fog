require 'fog/openstack/models/collection'
require 'fog/openstack/models/compute/service'

module Fog
  module Compute
    class OpenStack
      class Services < Fog::OpenStack::Collection
        model Fog::Compute::OpenStack::Service

        def all(options = {})
          load_response(service.list_services(options), 'services')
        end

        alias_method :summary, :all

        def details(options = {})
          Fog::Logger.deprecation('Calling OpenStack[:compute].services.details is deprecated, use .services.all')
          all(options)
        end
      end
    end
  end
end
