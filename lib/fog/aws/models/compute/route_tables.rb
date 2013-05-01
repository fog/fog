require 'fog/core/collection'
require 'fog/aws/models/compute/route_table'

module Fog
  module Compute
    class AWS

      class RouteTables < Fog::Collection

        attribute :filters

        model Fog::Compute::AWS::RouteTable

        # Creates a new route_table
        #
        # AWS.route_tables.new
        #
        # ==== Returns
        #
        # Returns the details of the new RouteTable
        #
        #>> AWS.route_tables.new
        # <Fog::AWS::Compute::RouteTable
        # route_table_id=route_table-someId,
        # vpc_id=vpc-someId
        # >
        #

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        # Returns an array of all RouteTables that have been created
        #
        # AWS.route_tables.all
        #
        # ==== Returns
        #
        # Returns an array of all VPCs
        #
        #>> AWS.route_tables.all
        # <Fog::AWS::Compute::RouteTable
        # filters={}
        # [
        # route_table_id=route_table-someId,
        # state=[pending|available],
        # vpc_id=vpc-someId
        # cidr_block=someIpRange
        # available_ip_address_count=someInt
        # tagset=nil
        # ]
        # >
        #

        def all(filters = filters)
          unless filters.is_a?(Hash)
            Fog::Logger.warning("all with #{filters.class} param is deprecated, use all('route_table-id' => []) instead [light_black](#{caller.first})[/]")
            filters = {'route_table-id' => [*filters]}
          end
          self.filters = filters
          data = service.describe_route_tables(filters).body
          load(data['routeTableSet'])
        end

        # Used to retrieve a RouteTable
        # route_table-id is required to get the associated VPC information.
        #
        # You can run the following command to get the details:
        # AWS.route_tables.get("route_table-12345678")
        #
        # ==== Returns
        #
        #>> AWS.route_tables.get("route_table-12345678")
        # <Fog::AWS::Compute::RouteTable
        # route_table_id=route_table-someId,
        # state=[pending|available],
        # vpc_id=vpc-someId
        # cidr_block=someIpRange
        # available_ip_address_count=someInt
        # tagset=nil
        # >
        #

        def get(route_table_id)
          if route_table_id
            self.class.new(:service => service).all('route_table-id' => route_table_id).first
          end
        end

      end

    end
  end
end
