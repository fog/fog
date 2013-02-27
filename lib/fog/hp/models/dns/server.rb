require 'fog/core/model'

module Fog
  module HP
    class DNS
      class Server

        identity :id
        attribute :name
        attribute :created_at
        attribute :updated_at

      end
    end
  end
end