require 'fog/core/model'

module Fog
  module Compute
    class IBM
      class Key < Fog::Model
        identity :name, :aliases => 'keyName'
        attribute :default
        attribute :public_key, :aliases => 'keyMaterial'
        attribute :last_modified, :aliases => 'lastModifiedTime'

        def save
          requires :name, :public_key
          data = connection.create_key(name, public_key)
          merge_attributes(data.body)
          data.body['success']
        end

        def destroy
          data = connection.delete_key(identity)
          data.body['success']
        end

      end
    end
  end
end
