require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector
      class EdgeGateway < Model
        identity  :id

        attribute :name
        attribute :type
        attribute :href
        attribute :configuration

      end
    end
  end
end
