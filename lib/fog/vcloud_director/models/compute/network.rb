require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector
      class Network < Model
        identity  :id

        attribute :name
        attribute :type
        attribute :href
        attribute :description
        attribute :is_inherited
        attribute :is_shared
        attribute :fence_mode
        attribute :gateway
        attribute :netmask
        attribute :dns1
        attribute :dns2
        attribute :dns_suffix
        attribute :ip_ranges, :type => :array
      end
    end
  end
end
