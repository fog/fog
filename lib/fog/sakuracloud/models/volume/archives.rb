require 'fog/core/collection'
require 'fog/sakuracloud/models/volume/archive'

module Fog
  module Volume
    class SakuraCloud
      class Archives < Fog::Collection
        model Fog::Volume::SakuraCloud::Archive

        def all
          load service.list_archives.body['Archives']
        end

        def get(id)
          all.find { |f| f.id == id }
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
