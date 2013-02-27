require 'fog/core/model'

module Fog
  module HP
    class DNS
      class Record

        #TODO attributes taken from early openstack ref
        identity :id
        attribute :name
        attribute :type
        attribute :ttl
        attribute :data
        attribute :domain_id
        attribute :tenant_id
        attribute :priority
        attribute :version


      end
    end
  end
end