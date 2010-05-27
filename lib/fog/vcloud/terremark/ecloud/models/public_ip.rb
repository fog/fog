require 'fog/model'

module Fog
  module Vcloud
    module Terremark
      module Ecloud
        class PublicIp < Fog::Vcloud::Model

          identity :href

          attribute :name
          attribute :type
          attribute :id
        end
      end
    end
  end
end

