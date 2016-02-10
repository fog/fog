require 'fog/openstack/core'

module Fog
  module Identity
    class OpenStack < Fog::Service

      # Fog::Identity::OpenStack.new() will return a Fog::Identity::OpenStack::V2 or a Fog::Identity::OpenStack::V3,
      #  depending on whether the auth URL is for an OpenStack Identity V2 or V3 API endpoint
      def self.new(args = {})
        @openstack_auth_uri = URI.parse(args[:openstack_auth_url]) if args[:openstack_auth_url]
        if self.inspect == 'Fog::Identity::OpenStack'
          service = (is_v3? args) ? Fog::Identity::OpenStack::V3.new(args) : Fog::Identity::OpenStack::V2.new(args)
        else
          service = Fog::Service.new(args)
        end
        service
      end

      private

      def self.is_v3?(args)
        @openstack_auth_uri && @openstack_auth_uri.path =~ /\/v3/
      end

    end
  end
end
