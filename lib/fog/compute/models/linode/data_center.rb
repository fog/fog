require 'fog/core/model'

module Fog
  module Linode
    class Compute
      class DataCenter < Fog::Model
        identity :id
        attribute :location
      end
    end
  end
end
