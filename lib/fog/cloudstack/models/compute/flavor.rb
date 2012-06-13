module Fog
  module Compute
    class Cloudstack
      class Flavor < Fog::Model
        identity  :id,              :aliases => 'id'
        attribute :cpu_number,      :aliases => 'cpunumber'
        attribute :cpu_speed,       :aliases => 'cpuspeed'
        attribute :created
        attribute :default_use,     :aliases => 'defaultuse'
        attribute :display_text,    :aliases => 'display_text'
        attribute :domain
        attribute :host_tags,       :aliases => 'host_tags'
        attribute :is_system,       :aliases => 'is_system'
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
      end # Server
    end # Cloudstack
  end # Compute
end # Fog
