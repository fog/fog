require 'fog/core/model'

module Fog
  module Compute
    class XenServer
    
      class Pool < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/5.6.0/1.0/en_gb/api/?c=pool
        
        identity :reference
        
        attribute :uuid
        attribute :name,                   :aliases => :name_label
        attribute :description,            :aliases => :name_description
        attribute :__default_sr,           :aliases => :default_SR
        attribute :__master,               :aliases => :master
        attribute :tags 
        attribute :restrictions
        attribute :ha_enabled
        attribute :vswitch_controller

        
        def default_sr
          connection.storage_repositories.get __default_sr
        end

        def default_storage_repository
          default_sr
        end

        def master
          connection.hosts.get __master
        end

      end
      
    end
  end
end
