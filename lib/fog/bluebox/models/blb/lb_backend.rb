require 'fog/core/model'

module Fog
  module Bluebox
    class BLB

      class Backend < Fog::Model
        identity :id
        
        attribute :name
        attribute :machines
        attribute :monitoring_url
        attribute :monitoring_url_hostname
        attribute :acl_name
        attribute :acl_rule
        attribute :check_interval

      end

    end
  end
end
