require 'fog/core/collection'
require 'fog/cloudstack/models/compute/ostype'
module Fog
  module Compute
    class Cloudstack

      class Ostypes < Fog::Collection

        model Fog::Compute::Cloudstack::Ostype
        def all(filters={})
          data = service.list_os_types(filters)["listostypesresponse"]["ostype"]
          load(data)
        end
      end
    end
  end
end
