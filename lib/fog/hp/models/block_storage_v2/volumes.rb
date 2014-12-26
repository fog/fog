require 'fog/core/collection'
require 'fog/hp/models/block_storage_v2/volume'

module Fog
  module HP
    class BlockStorageV2
      class Volumes < Fog::Collection
        attribute :filters

        model Fog::HP::BlockStorageV2::Volume

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters_arg = filters)
          details = filters_arg.delete(:details)
          self.filters = filters_arg
          non_aliased_filters = Fog::HP.convert_aliased_attributes_to_original(self.model, filters)
          if details
            data = service.list_volumes_detail(non_aliased_filters).body['volumes']
          else
            data = service.list_volumes(non_aliased_filters).body['volumes']
          end
          load(data)
        end

        def get(volume_id)
          volume = service.get_volume_details(volume_id).body['volume']
          new(volume)
        rescue Fog::HP::BlockStorageV2::NotFound
          nil
        end
      end
    end
  end
end
