require 'fog/core/model'

module Fog
  module Linode
    class Compute
      class Ip < Fog::Model
        identity :id
        attribute :ip
        attribute :public
      end
    end
  end
end
