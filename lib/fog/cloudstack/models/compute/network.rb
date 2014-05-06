module Fog
  module Compute
    class Cloudstack
      class Network < Fog::Model
        identity  :id
        attribute :name
        attribute :services,                   :type => :array, :aliases => 'service'
      end
    end
  end
end
