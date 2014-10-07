require 'fog/core/model'
require 'fog/hp/models/storage/meta_parent'

module Fog
  module Storage
    class HP
      class Meta < Fog::Model
        include Fog::Storage::HP::MetaParent

        identity :key
        attribute :value

        def destroy
          false
        end

        def save
          requires :identity, :value
          if @parent.key
            service.put_container(@parent.key, {key => value})
            true
          end
        end
      end
    end
  end
end
