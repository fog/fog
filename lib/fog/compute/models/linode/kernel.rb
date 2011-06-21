require 'fog/core/model'

module Fog
  module Compute
    class Linode
      class Kernel < Fog::Model
        identity :id
        attribute :name
      end
    end
  end
end
