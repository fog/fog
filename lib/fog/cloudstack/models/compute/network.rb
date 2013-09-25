module Fog
  module Compute
    class Cloudstack
      class Network < Fog::Model
        identity  :id
        attribute :name

      end
    end
  end
end