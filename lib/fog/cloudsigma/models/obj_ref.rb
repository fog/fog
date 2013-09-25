require 'fog/core/model'

module Fog
  module Compute
    class CloudSigma
      class ObjRef < Fog::Model
        attribute :uuid, :type => :string
        attribute :resource_uri, :type => :string
      end
    end
  end
end
