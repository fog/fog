require 'fog/core/model'

module Fog
  module Compute
    class Brightbox

      class Zone < Fog::Model

        identity :id
        attribute :url
        attribute :resource_type

        attribute :status
        attribute :handle

        attribute :description

      end

    end
  end
end