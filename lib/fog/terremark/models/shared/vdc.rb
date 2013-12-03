require 'fog/core/model'

module Fog
  module Terremark
    module Shared

      class Vdc < Fog::Model

        identity :id

        attribute :name
        attribute :ResourceEntities
        attribute :AvailableNetworks
        attribute :links
        def networks
          service.networks(:vdc_id => id)
        end

        def addresses
          service.addresses(:vdc_id => id)
        end

        def servers
          service.servers(:vdc_id => id)
        end

        def images
          service.images(:vdc_id => id)
        end
        private

        def href=(new_href)
          self.id = new_href.split('/').last.to_i
        end

        def type=(new_type); end

        def rel=(new_rel); end

      end

    end
  end
end
