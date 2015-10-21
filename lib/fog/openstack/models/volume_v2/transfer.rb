require 'fog/openstack/models/volume/transfer'

module Fog
  module Volume
    class OpenStack
      class V2
        class Transfer < Fog::Volume::OpenStack::Transfer
          identity :id

          attribute :auth_key, :aliases => 'authKey'
          attribute :created_at, :aliases => 'createdAt'
          attribute :name
          attribute :volume_id, :aliases => 'volumeId'

        end
      end
    end
  end
end
