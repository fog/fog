require 'fog/core/collection'
require 'fog/aws/models/rds/parameter'

module Fog
  module AWS
    class RDS

      class Parameters < Fog::Collection
        attribute :group
        attribute :filters
        model Fog::AWS::RDS::Parameter

        def initialize(attributes)
          self.filters ||= {}
          if attributes[:source]
            filters[:source] = attributes[:source]
          end
          super
        end

        def all(filters = filters)
          self.filters = filters
          result = []
          marker = nil
          finished = false
          while !finished
            data = connection.describe_db_parameters(group.id, filters.merge(:marker => marker)).body
            result.concat(data['DescribeDBParametersResult']['Parameters'])
            marker = data['DescribeDBParametersResult']['Marker']
            finished = marker.nil?
          end
          load(result) # data is an array of attribute hashes
        end
      end
    end
  end
end