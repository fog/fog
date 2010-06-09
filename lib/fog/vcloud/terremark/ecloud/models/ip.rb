require 'fog/model'

module Fog
  module Vcloud
    module Terremark
      module Ecloud
        class Ip < Fog::Vcloud::Model

          identity :name

          attribute :status
          attribute :server

        end
      end
    end
  end
end
