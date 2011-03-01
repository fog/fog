require 'fog/core/model'

module Fog
  module Linode
    class Compute
      class Kernel < Fog::Model
        identity :id
        attribute :name
      end
    end
  end
end
