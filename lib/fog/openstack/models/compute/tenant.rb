require 'fog/core/model'

module Fog
  module Compute
    class OpenStack
      class Tenant < Fog::Model
        identity :id

        attribute :description
        attribute :enabled
        attribute :name

        def to_s
          self.name
        end

        def usage(start_date, end_date)
          requires :id
          connection.get_usage(self.id, start_date, end_date).body['tenant_usage']
        end
      end # class Tenant
    end # class OpenStack
  end # module Compute
end # module Fog
