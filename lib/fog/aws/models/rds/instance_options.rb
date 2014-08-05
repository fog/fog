require 'fog/core/collection'
require 'fog/aws/models/rds/instance_option'

module Fog
  module AWS
    class RDS
      class InstanceOptions < Fog::PagedCollection
        attribute :filters
        attribute :engine
        model Fog::AWS::RDS::InstanceOption

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        # This method deliberately returns only a single page of results
        def all(filters=filters)
          self.filters.merge!(filters)

          result = service.describe_orderable_db_instance_options(engine, self.filters).body['DescribeOrderableDBInstanceOptionsResult']
          self.filters[:marker] = result['Marker']
          load(result['OrderableDBInstanceOptions'])
        end
      end
    end
  end
end
