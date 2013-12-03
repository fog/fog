require 'fog/core/model'

module Fog
  module DNS
    class Dynect

      class Record < Fog::Model
        extend Fog::Deprecation

        identity  :id
        attribute :name,        :aliases => [:fqdn, 'fqdn']
        attribute :rdata
        attribute :serial_style
        attribute :ttl
        attribute :type,        :aliases => 'record_type'

        def destroy
          requires :identity, :name, :type, :zone
          service.delete_record(type, zone.identity, name, identity)
          true
        end

        def save
          requires :name, :type, :rdata, :zone

          options = {
            :ttl => ttl
          }
          options.delete_if {|key, value| value.nil?}

          data = service.post_record(type, zone.identity, name, rdata, options).body['data']
          # avoid overwriting zone object with zone string
          data = data.reject {|key, value| key == 'zone'}
          merge_attributes(data)

          zone.publish
          records = service.get_record(type, zone.identity, name).body['data']
          # data in format ['/REST/xRecord/domain/fqdn/identity]
          records.map! do |record|
            tokens = record.split('/')
            {
              :identity => tokens.last,
              :type     => tokens[2][0...-6] # everything before 'Record'
            }
          end
          record = records.detect {|record| record[:type] == type}
          merge_attributes(record)

          true
        end

        def zone
          @zone
        end

        private

        def zone=(new_zone)
          @zone = new_zone
        end

      end

    end
  end
end
