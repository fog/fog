require 'fog/core/model'

module Fog
  module HP
    class DNS
      class Domain

        identity :id
        attribute :name
        attribute :ttl
        attribute :serial
        attribute :email
        attribute :created_at

      end
    end
  end
end