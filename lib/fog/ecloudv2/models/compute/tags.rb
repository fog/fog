require 'fog/ecloudv2/models/compute/tag'

module Fog
  module Compute
    class Ecloudv2
      class Tags < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::Tag

        def all
          data = connection.get_tags(href).body[:DeviceTag]
          load(data)
        end

        def get(uri)
          if data = connection.get_tag(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
