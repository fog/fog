require 'fog/core/collection'
require 'fog/compute/models/ninefold/image'

module Fog
  module Ninefold
    class Compute

      class Images < Fog::Collection

        model Fog::Ninefold::Compute::Image

        def all(offering = 'executable')
          data = connection.list_templates(:templatefilter => offering)
          load(data)
        end

        def get(identifier, offering = 'executable')
          data = connection.list_templates(:templatefilter => offering, :id => identifier)
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
