require 'fog/core/model'

module Fog
  module Compute
    class Libvirt

      class Interface < Fog::Model

        identity :name

        attribute :mac
        attribute :xml

        def save
          raise Fog::Errors::Error.new('Creating a new interface is not yet implemented. Contributions welcome!')
        end

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
            :name => new_raw.name,
            :mac => new_raw.mac,
            :xml => new_raw.xml_desc,
          }

          merge_attributes(raw_attributes)

        end

      end

    end
  end

end
