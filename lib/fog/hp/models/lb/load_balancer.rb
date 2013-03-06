require 'fog/core/model'

module Fog
  module HP
    class LB
      #"name" : "lb-site1",
      #    "id" : "71",
      #    "protocol" : "HTTP",
      #    "port" : "80",
      #    "algorithm" : "LEAST_CONNECTIONS",
      #    "status" : "ACTIVE",
      #    "created" : "2010-11-30T03:23:42Z",
      #    "updated" : "2010-11-30T03:23:44Z"
      class LoadBalancer < Fog::Model

        identity :id
        attribute :name
        attribute :protocol
        attribute :port
        attribute :algorithm
        attribute :status
        attribute :created_at, :aliases => 'created'
        attribute :updated_at , :aliases => 'updated'

      end
    end
  end
end