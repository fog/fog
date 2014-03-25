require 'fog/core/model'
require 'fog/rackspace/models/monitoring/base'

module Fog
  module Rackspace
    class Monitoring
      class CheckType < Fog::Rackspace::Monitoring::Base
        identity :id
        attribute :type
        attribute :fields
        attribute :channel
      end
    end
  end
end
