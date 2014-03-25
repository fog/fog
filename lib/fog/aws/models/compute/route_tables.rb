require 'fog/core/collection'
require 'fog/aws/models/compute/route_table'

module Fog
  module Compute
    class AWS

      class RouteTables < Fog::Collection

        attribute :filters

        model Fog::Compute::AWS::RouteTable

        # Creates a new route table
        #
        # AWS.route_tables.new
        #
        # ==== Returns
        #
        # Returns the details of the new route table
        #
        #>> AWS.route_tables.new
        # <Fog::Compute::AWS::RouteTable
        # id=nil,
        # vpc_id=nil,
        # routes=nil,
        # associations=nil,
        # tags=nil
        # >
        #

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        # Returns an array of all route tables that have been created
        #
        # AWS.route_tables.all
        #
        # ==== Returns
        #
        # Returns an array of all route tables
        #
        #>> AWS.route_tables.all
        # <Fog::Compute::AWS::RouteTables
        # filters={}
        # [
        # <Fog::Compute::AWS::RouteTable
        # id="rtb-41e8552f",
        # TODO
        # >
        # ]
        # >
        #

        def all(filters = filters)
          unless filters.is_a?(Hash)
            Fog::Logger.warning("all with #{filters.class} param is deprecated, use all('route-table-id' => []) instead [light_black](#{caller.first})[/]")
            filters = {'route-table-id' => [*filters]}
          end
          self.filters = filters
          data = service.describe_route_tables(filters).body
          load(data['routeTableSet'])
        end

        # Used to retrieve a route table
        # route_table_id is required to get the associated route table information.
        #
        # You can run the following command to get the details:
        # AWS.route_tables.get("rtb-41e8552f")
        #
        # ==== Returns
        #
        #>> AWS.route_tables.get("rtb-41e8552f")
        # <Fog::Compute::AWS::RouteTable
        # id="rtb-41e8552f",
        # TODO
        # >
        #

        def get(route_table_id)
          if route_table_id
            self.class.new(:service => service).all('route-table-id' => route_table_id).first
          end
        end

      end

    end
  end
end
