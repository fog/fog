require 'fog/openstack/models/collection'
require 'fog/openstack/models/volume_v1/transfer'
require 'fog/openstack/models/volume/transfers'

module Fog
  module Volume
    class OpenStack
      class V1
        class Transfers < Fog::OpenStack::Collection
          model Fog::Volume::OpenStack::V1::Transfer
          include Fog::Volume::OpenStack::Transfers
        end
      end
    end
  end
end
