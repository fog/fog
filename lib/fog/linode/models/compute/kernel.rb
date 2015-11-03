require 'fog/core/model'

module Fog
  module Compute
    class Linode
      class Kernel < Fog::Model
        identity :id
        attribute :name
        attribute :is_xen
        attribute :is_kvm
        attribute :is_pvops
      end
    end
  end
end
