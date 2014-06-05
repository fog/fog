require 'fog/core/collection'
require 'fog/ninefold/models/compute/image'

module Fog
  module Compute
    class Ninefold
      class Images < Fog::Collection
        model Fog::Compute::Ninefold::Image

        def all(offering = 'executable')
          data = service.list_templates(:templatefilter => offering)
          load(data)
        end

        def get(identifier, offering = 'executable')
          data = service.list_templates(:templatefilter => offering, :id => identifier)
          if data.empty?
            nil
          else
            new(data[0])
          end
        end
      end
    end
  end
end
