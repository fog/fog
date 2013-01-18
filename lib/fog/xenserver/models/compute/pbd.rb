require 'fog/core/model'

module Fog
  module Compute
    class XenServer

      class PBD < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/5.6.0/1.0/en_gb/api/?c=PBD

        identity :reference

        attribute :uuid
        attribute :__host,             :aliases => :host
        attribute :__sr,               :aliases => :SR
        attribute :currently_attached

        def sr
          service.storage_repositories.get __sr
        end

        def storage_repository
          sr
        end

        def host
          service.hosts.get __host
        end
        
        def unplug
          service.unplug_pbd reference
        end

      end

    end
  end
end
