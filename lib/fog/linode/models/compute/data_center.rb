require 'fog/core/model'

module Fog
  module Compute
    class Linode
      class DataCenter < Fog::Model
        identity :id
        attribute :location
        attribute :abbr
      end
    end
  end
end
