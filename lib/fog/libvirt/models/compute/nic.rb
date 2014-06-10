require 'fog/core/model'

module Fog
  module Compute
    class Libvirt
      class Nic < Fog::Model
        identity :mac
        attribute :id
        attribute :type
        attribute :network
        attribute :bridge
        attribute :model

        attr_accessor :server

        TYPES = ["network", "bridge", "user"]

        def new?
          mac.nil?
        end

        def initialize attributes
          super defaults.merge(attributes)
          raise Fog::Errors::Error.new("#{type} is not a supported nic type") if new? && !TYPES.include?(type)
        end

        def save
          raise Fog::Errors::Error.new('Creating a new nic is not yet implemented. Contributions welcome!')
          #requires :server
          #service.attach_nic(domain , self)
        end

        def destroy
          raise Fog::Errors::Error.new('Destroying an interface is not yet implemented. Contributions welcome!')
          #requires :server
          ##detach the nic
          #service.detach_nic(domain, mac)
        end

        private
        def defaults
          {
            :type  => "bridge",
            :model => "virtio"
          }
        end
      end
    end
  end
end
