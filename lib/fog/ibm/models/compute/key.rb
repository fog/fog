require 'fog/core/model'

module Fog
  module Compute
    class IBM
      class Key < Fog::Model
        identity :name, :aliases => 'keyName'
        attribute :default
        attribute :public_key, :aliases => 'keyMaterial'
        attribute :instance_ids, :aliases => 'instanceIds'
        attribute :modified_at, :aliases => 'lastModifiedTime'

        def save
          requires :name
          data = service.create_key(name, public_key)
          merge_attributes(data.body)
          data.body['keyName'] == name
        end

        def destroy
          data = service.delete_key(identity)
          data.body['success']
        end

        def default?
          default
        end

        def instances
          instance_ids.map { Fog::Compute[:ibm].servers.get(instance_id) }
        end
      end
    end
  end
end
