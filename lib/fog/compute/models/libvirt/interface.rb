require 'fog/core/model'

module Fog
  module Compute
    class Libvirt

      class Interface < Fog::Model

        identity :id
        
        attribute :mac
        attribute :name
        attribute :xml_desc

        def destroy
          requires :raw
          raw.delete
          true
        end
        
        private

        def raw
          @raw
        end

        def raw=(new_raw)
          @raw = new_raw

          raw_attributes = { 
            :id => new_raw.name,
            :name => new_raw.name,
            :mac => new_raw.mac,
            :xml_desc => new_raw.xml_desc,
          }

          merge_attributes(raw_attributes)

        end
        
      end

    end
  end

end
