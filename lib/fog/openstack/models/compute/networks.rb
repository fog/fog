require 'fog/core/collection'
require 'fog/openstack/models/compute/network'

module Fog
  module Compute
    class OpenStack
      class Networks < Fog::Collection
        model Fog::Compute::OpenStack::Network

        attribute :server

        def all
          requires :server

          networks = Array.new
          server.addresses.each_with_index do |address, index|
            networks << {
              :id   => index + 1,
              :name => address[0],
              :addresses => address[1].map {|a| a['addr'] }
            }
          end

          load(networks)
        end
      end # class Networks
    end # class OpenStack
  end # module Compute
end # module Fog
