require 'fog/ecloud/models/compute/rnat'

module Fog
  module Compute
    class Ecloud
      class Rnats < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::Rnat

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
