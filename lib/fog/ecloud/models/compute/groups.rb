require 'fog/ecloud/models/compute/group'

module Fog
  module Compute
    class Ecloud
      class Groups < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::Group

        def all
          data = service.get_groups(href).body
          data = if data == ""
                   ""
                 else
                   data[:Groups] ? data[:Groups][:Group] : data
                 end
          if data == "" || !data.is_a?(Array) && data[:type] == "application/vnd.tmrk.cloud.layoutRow"
            nil
          else
            load(data)
          end
        end

        def get(uri)
          data = service.get_group(uri).body
          if data == ""
            nil
          else
            new(data)
          end
        rescue Excon::Errors::NotFound
          nil
        end
      end
    end
  end
end
