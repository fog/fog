require 'fog/model'

module Fog
  module Vcloud
    class Vdc < Fog::Vcloud::Model

      identity :href

      attribute :name
      attribute :other_links, :links
      attribute :resource_entity_links, :resource_entities
      attribute :network_links, :networks
      attribute :cpu_capacity
      attribute :storage_capacity
      attribute :memory_capacity
      attribute :vm_quota
      attribute :enabled
      attribute :nic_quota
      attribute :network_quota
      attribute :vcloud_type, :type
      attribute :xmlns
      attribute :description
      attribute :allocation_model

      #def networks
      #  connection.networks(:vdc_uri => @uri)
      #end

      #def addresses
      #  connection.addresses(:vdc_uri => @uri)
      #end

    end

  end
end
