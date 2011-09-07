require 'fog/core/model'

module Fog
  module Compute
    class Linode
      class DataCenter < Fog::Model
        identity :id
        attribute :location
      end
    end
  end
end
