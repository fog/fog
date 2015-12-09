require 'fog/openstack/models/collection'
require 'fog/openstack/models/volume_v2/transfer'
require 'fog/openstack/models/volume/transfers'

module Fog
  module Volume
    class OpenStack
      class V2
        class Transfers < Fog::OpenStack::Collection
          model Fog::Volume::OpenStack::V2::Transfer
          include Fog::Volume::OpenStack::Transfers
        end
      end
    end
  end
end
