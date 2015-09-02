require 'fog/openstack/models/model'

module Fog
  module Volume
    class OpenStack
      class VolumeType < Fog::OpenStack::Model
        identity :id

        attribute :name
        attribute :volume_backend_name
      end
    end
  end
end
