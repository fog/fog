require 'fog/ecloud/models/compute/association'

module Fog
  module Compute
    class Ecloud
      class Associations < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::Association

        def all
          data = service.get_associations(href).body
          if data[:Associations]
            data = data[:Associations]
            if data.is_a?(String) && data.empty?
              data = []
            elsif data.is_a?(Hash)
              data = data[:Association]
            end
          end
          load(data)
        end

        def get(uri)
          if data = service.get_association(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
