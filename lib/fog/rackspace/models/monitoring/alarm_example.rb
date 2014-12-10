require 'fog/core/model'
require 'fog/rackspace/models/monitoring/base'

module Fog
  module Rackspace
    class Monitoring
      class AlarmExample < Fog::Rackspace::Monitoring::Base
        identity :id

        attribute :label
        attribute :description
        attribute :check_type
        attribute :criteria
        attribute :fields

        attribute :bound_criteria

        def bound?
          !bound_criteria.nil?
        end
      end
    end
  end
end
