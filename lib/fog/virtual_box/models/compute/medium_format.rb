require 'fog/core/model'

module Fog
  module Compute
    class VirtualBox

      class MediumFormat < Fog::Model

        identity :id

        # attribute :capabilities
        attribute :name

        private

        def raw
          @raw
        end
        
        def raw=(new_raw)
          @raw = new_raw
          raw_attributes = {}
          for key in [:id, :name]
            raw_attributes[key] = @raw.send(key)
          end
          merge_attributes(raw_attributes)
        end

      end

    end
  end

end
