require 'fog/core/collection'
require 'fog/rackspace/models/cdn_v2/service'

module Fog
  module Rackspace
    class CDNV2 < Fog::Service
      class Services < Fog::Collection
        model Fog::Rackspace::CDNV2::Service

        def all(options={})
          data = service.list_services(options).body['services']
          load(data)
        end

        def get(id)
          data = service.get_service(id).body
          new(data)
        rescue Fog::Rackspace::CDNV2::NotFound
          nil
        end
      end
    end
  end
end
