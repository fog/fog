require 'fog/ecloud/models/compute/group'

module Fog
  module Compute
    class Ecloud
      class Groups < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::Group

        def all
          data = connection.get_groups(href).body
          data = data[:Groups] ? data[:Groups][:Group] : data
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
