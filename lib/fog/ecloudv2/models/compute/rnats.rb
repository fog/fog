require 'fog/ecloudv2/models/compute/rnat'

module Fog
  module Compute
    class Ecloudv2
      class Rnats < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::Rnat

        def all
          data = connection.get_rnats(href).body[:Rnats][:Rnat]
          load(data)
        end

        def get(uri)
          if data = connection.get_rnat(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
