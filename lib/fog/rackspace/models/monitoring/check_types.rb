require 'fog/core/collection'
require 'fog/rackspace/models/monitoring/check_type'

module Fog
  module Rackspace
    class Monitoring
      class CheckTypes < Fog::Collection
        model Fog::Rackspace::Monitoring::CheckType

        def all
          data = service.list_check_types.body['values']
          load(data)
        end

        def new(attributes = {})
          super({ }.merge!(attributes))
        end
      end
    end
  end
end
