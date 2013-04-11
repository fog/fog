require 'fog/core/collection'
require 'fog/aws/models/compute/route_table'

module Fog
  module Compute
    class AWS

      class RouteTables < Fog::Collection

        attribute :filters

        model Fog::Compute::AWS::RouteTable

        # Creates a new VPC
        #
        # AWS.vpcs.new
        #
        # ==== Returns
        #
        # Returns the details of the new VPC
        #
        #>> AWS.vpcs.new
        # <Fog::AWS::VPC::VPC
        # id=nil,
        # state=nil,
        # cidr_block=nil,
        # dhcp_options_id=nil
        # tags=nil
        # tenancy=nil
        # >
        #

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        # Returns an array of all VPCs that have been created
        #
        # AWS.vpcs.all
        #
        # ==== Returns
        #
        # Returns an array of all VPCs
        #
        #>> AWS.vpcs.all
        # <Fog::AWS::VPC::VPCs
        # filters={}
        # [
        # <Fog::AWS::VPC::VPC
        # id="vpc-12345678",
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

        # Used to retrieve a VPC
        # vpc_id is required to get the associated VPC information.
        #
        # You can run the following command to get the details:
        # AWS.vpcs.get("vpc-12345678")
        #
        # ==== Returns
        #
        #>> AWS.vpcs.get("vpc-12345678")
        # <Fog::AWS::Compute::VPC
        # id="vpc-12345678",
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
