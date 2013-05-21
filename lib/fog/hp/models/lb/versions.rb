require 'fog/core/collection'
require 'fog/hp/models/lb/version'

module Fog
  module HP
    class LB
      class Versions < Fog::Collection
        model Fog::HP::LB::Version

        def all
          data = service.list_versions.body['versions']
          load(data)
        end

        def get(record_id)
          record = service.get_versions(record_id).body['version']
          new(record)
        rescue Fog::HP::LB::NotFound
          nil
        end

      end
    end
  end
end
