module Fog
  module Compute
    class Cloudstack
      class Flavor < Fog::Model
        identity  :id,              :aliases => 'id'
        attribute :cpu_number,      :aliases => 'cpunumber'
        attribute :cpu_speed,       :aliases => 'cpuspeed'
        attribute :created,         :type => :time
        attribute :default_use,     :aliases => 'defaultuse'
        attribute :display_text,    :aliases => 'display_text'
        attribute :domain
        attribute :host_tags,       :aliases => 'host_tags'
        attribute :is_system,       :aliases => 'issystem', :type => :boolean
        attribute :is_volatile,     :aliases => 'isvolatile', :type => :boolean
        attribute :is_customized,   :aliases => 'iscustomized', :type => :boolean
        attribute :limit_cpu_use,   :aliases => 'limitcpuuse'
        attribute :tags
        attribute :system_vm_type,  :aliases => 'systemvm'
        attribute :storage_type,    :aliases => 'storagetype'
        attribute :offer_ha,        :aliases => 'offerha'
        attribute :network_rate,    :aliases => 'networkrate'
        attribute :name
        attribute :memory

        def save
          raise Fog::Errors::Error.new('Creating a flavor is not supported')
        end

        def destroy
          raise Fog::Errors::Error.new('Destroying a flavor is not supported')
        end

      end # Flavor
    end # Cloudstack
  end # Compute
end # Fog
