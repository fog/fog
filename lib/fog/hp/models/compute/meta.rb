require 'fog/core/model'
require 'fog/hp/models/meta_parent'

module Fog
  module Compute
    class HP
      class Meta < Fog::Model
        include Fog::Compute::HP::MetaParent

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
