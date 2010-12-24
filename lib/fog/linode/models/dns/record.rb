require 'fog/core/model'

module Fog
  module Linode
    class DNS

      class Record < Fog::Model

        identity :id,         :aliases => ['ResourceID', 'RESOURCEID']

        attribute :ip,        :aliases => 'TARGET'
        attribute :name,      :aliases => 'NAME'
        attribute :priority,  :aliases => 'PRIORITY'
        attribute :ttl,       :aliases => 'TTL_SEC'
        attribute :type,      :aliases => 'TYPE'
        attribute :zone_id,   :aliases => 'DOMAINID'

        # "PROTOCOL":"",
        # "WEIGHT":0,
        # "PORT":0,

        def initialize(attributes={})
          self.ttl    ||= 3600
          super
        end

        def destroy
          requires :identity
          connection.domain_resource_delete(identity)
          true
        end

        def zone
          @zone
        end

        def save
          requires :type, :zone
          options = {}
          # * options<~Hash>
          #   * weight<~Integer>: default: 5
          #   * port<~Integer>: default: 80 
          #   * protocol<~String>: The protocol to append to an SRV record. Ignored on other record 
          #                        types. default: udp
          options[:name]      = name if name
          options[:priority]  = priority if priority
          options[:target]    = ip if ip
          options[:ttl_sec]   = ttl if ttl
          data = unless identity
            connection.domain_resource_create(zone.id, type)
          else
            options[:type] = type if type
            connection.domain_resource_update(zone.id, identity, optionts)
          end
          merge_attributes(data.body)
          true
        end

        private
        
        def zone=(new_zone)
          @zone = new_zone
        end

      end

    end
  end
end
