require 'fog/ecloud/models/compute/row'

module Fog
  module Compute
    class Ecloud
      class Rows < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::Row

        def all
          data = connection.get_layout(href).body[:Rows][:Row]
          load(data)
        end

        def get(uri)
          if data = connection.get_row(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

        def create(options = {})
          options[:uri] = "/cloudapi/ecloud/layoutRows/environments/#{environment_id}/action/createLayoutRow"
          data = connection.rows_create(options).body
          new(data)
        end
 
        def environment_id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
