require 'fog/core/model'

module Fog
  module Compute
    class Brightbox

      class Zone < Fog::Model

        identity :id

        attribute :url
        attribute :handle
        attribute :status
        attribute :resource_type
        attribute :description

      end

    end
  end
end