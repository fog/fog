require 'fog/ecloud/models/compute/tag'

module Fog
  module Compute
    class Ecloud
      class Tags < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::Tag

        def all
          data = service.get_tags(href).body[:DeviceTag]
          load(data)
        end

        def get(uri)
          if data = service.get_tag(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
