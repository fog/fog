require 'fog/openstack/core'
require 'fog/openstack/identity_v2'
require 'fog/openstack/identity_v3'

module Fog
  module Identity
    class OpenStack < Fog::Service

      # Fog::Identity::OpenStack.new() will return a Fog::Identity::OpenStack::V2 or a Fog::Identity::OpenStack::V3,
      #  depending on whether the auth URL is for an OpenStack Identity V2 or V3 API endpoint
      def self.new(args = {})
        if self.inspect == 'Fog::Identity::OpenStack'
          if args[:openstack_auth_url]
            @openstack_auth_uri = URI.parse(args[:openstack_auth_url])
            if @openstack_auth_uri.path =~ /\/v3/
              service = Fog::Identity::OpenStack::V3.new(args)
              OpenStack.const_set('Mock', Fog::Identity::OpenStack::V3::Mock)
              OpenStack.const_set('Real', Fog::Identity::OpenStack::V3::Mock)
            end
          end
          service ||= Fog::Identity::OpenStack::V2.new(args)
        else
          service = Fog::Service.new(args)
        end
        service
      end

      class Mock < Fog::Identity::OpenStack::V2::Mock
      end
      class Real < Fog::Identity::OpenStack::V2::Real
      end
    end


  end
end
