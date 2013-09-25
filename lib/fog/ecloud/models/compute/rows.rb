require 'fog/ecloud/models/compute/row'

module Fog
  module Compute
    class Ecloud
      class Rows < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::Row

        def all
          data = service.get_layout(href).body[:Rows][:Row]
          load(data)
        end

        def get(uri)
          data = service.get_row(uri).body
          if data == ""
            nil
          else
            new(data)
          end
        rescue Excon::Errors::NotFound
          nil
        end

        def create(options = {})
          options[:uri] = "/cloudapi/ecloud/layoutRows/environments/#{environment_id}/action/createLayoutRow"
          data = service.rows_create(options).body
          new(data)
        end

        def environment_id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
