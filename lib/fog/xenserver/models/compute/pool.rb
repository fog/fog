require 'fog/core/model'

module Fog
  module Compute
    class XenServer

      class Pool < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=pool

        identity :reference

        attribute :uuid
        attribute :blobs
        attribute :__crash_dump_sr,        :aliases => :crash_dump_SR
        attribute :name,                   :aliases => :name_label
        attribute :description,            :aliases => :name_description
        attribute :__default_sr,           :aliases => :default_SR
        attribute :gui_config
        attribute :ha_allow_overcommit
        attribute :ha_configuration
        attribute :__master,               :aliases => :master
        attribute :tags
        attribute :restrictions
        attribute :ha_enabled
        attribute :ha_host_failures_to_tolerate
        attribute :ha_overcommitted
        attribute :ha_plan_exists_for
        attribute :ha_statefiles
        attribute :__metadata_vdis,        :aliases => :metadata_VDIs
        attribute :other_config
        attribute :redo_log_enabled
        attribute :redo_log_vdi
        attribute :vswitch_controller
        attribute :__suspend_image_sr,     :aliases => :suspend_image_SR
        attribute :wlb_enabled
        attribute :wlb_url
        attribute :wlb_username
        attribute :wlb_verify_cert


        def default_sr
          service.storage_repositories.get __default_sr
        end

        def default_sr=(sr)
          service.set_attribute( 'pool', reference, 'default_SR', sr.reference )
        end
        alias :default_storage_repository= :default_sr=

        def default_storage_repository
          default_sr
        end

        def suspend_image_sr=(sr)
          service.set_attribute( 'pool', reference, 'suspend_image_SR', sr.reference )
        end

        def suspend_image_sr
          service.storage_repositories.get __suspend_image_sr
        end

        def master
          service.hosts.get __master
        end
        
        def set_attribute(name, *val)
          data = service.set_attribute( 'pool', reference, name, *val )
          # Do not reload automatically for performance reasons
          # We can set multiple attributes at the same time and
          # then reload manually
          #reload
        end

      end

    end
  end
end
