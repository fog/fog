require 'fog/core/collection'
require 'fog/virtual_box/models/compute/nat_redirect'

module Fog
  module Compute
    class VirtualBox

      class NATRedirects < Fog::Collection

        model Fog::Compute::VirtualBox::NATRedirect

        attr_accessor :machine, :nat_engine

        def all
          requires :machine, :nat_engine
          data = nat_engine.instance_variable_get(:@raw).redirects.map do |nat_redirect|
            {
              :machine  => machine,
              :raw      => nat_redirect
            }
          end
          load(data)
        end

        def get(nat_redirect_name)
          requires :machine, :nat_engine
          all.detect do |nat_redirect|
            nat_redirect.name == nat_redirect_name
          end
        end

        def new(attributes = {})
          requires :machine, :nat_engine
          super({:machine => machine, :nat_engine => nat_engine}.merge!(attributes))
        end

      end

    end
  end
end
