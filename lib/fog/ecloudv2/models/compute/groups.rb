require 'fog/ecloudv2/models/compute/group'

module Fog
  module Compute
    class Ecloudv2
      class Groups < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::Group

        def all
          data = connection.get_groups(href).body[:Groups][:Group]
          load(data)
        end

        def get(uri)
          if data = connection.get_group(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
