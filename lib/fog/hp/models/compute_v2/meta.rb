require 'fog/core/model'
require 'fog/hp/models/compute_v2/meta_parent'

module Fog
  module Compute
    class HPV2
      class Meta < Fog::Model
        include Fog::Compute::HPV2::MetaParent

        identity :key
        attribute :value

        def destroy
          requires :identity
          service.delete_meta(collection_name, @parent.id, key)
          true
        end

        def save
          requires :identity, :value
          service.update_meta(collection_name, @parent.id, key, value)
          true
        end
      end
    end
  end
end
