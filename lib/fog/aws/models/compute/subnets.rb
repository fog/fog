require 'fog/core/collection'
require 'fog/aws/models/compute/subnet'

module Fog
  module Compute
    class AWS

      class Subnets < Fog::Collection

        attribute :filters

        model Fog::Compute::AWS::Subnet

        # Creates a new subnet
        #
        # AWS.subnets.new
        #
        # ==== Returns
        #
        # Returns the details of the new Subnet
        #
        #>> AWS.subnets.new
        # <Fog::AWS::Compute::Subnet
        # subnet_id=subnet-someId,
        # state=[pending|available],
        # vpc_id=vpc-someId
        # cidr_block=someIpRange
        # available_ip_address_count=someInt
        # tagset=nil
        # >
        #

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        # Returns an array of all Subnets that have been created
        #
        # AWS.subnets.all
        #
        # ==== Returns
        #
        # Returns an array of all VPCs
        #
        #>> AWS.subnets.all
        # <Fog::AWS::Compute::Subnet
        # filters={}
        # [
        # subnet_id=subnet-someId,
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
            Fog::Logger.warning("all with #{filters.class} param is deprecated, use all('subnet-id' => []) instead [light_black](#{caller.first})[/]")
            filters = {'subnet-id' => [*filters]}
          end
          self.filters = filters
          data = connection.describe_subnets(filters).body
          load(data['subnetSet'])
        end

        # Used to retrieve a Subnet
        # subnet-id is required to get the associated VPC information.
        #
        # You can run the following command to get the details:
        # AWS.subnets.get("subnet-12345678")
        #
        # ==== Returns
        #
        #>> AWS.subnets.get("subnet-12345678")
        # <Fog::AWS::Compute::Subnet
        # subnet_id=subnet-someId,
        # state=[pending|available],
        # vpc_id=vpc-someId
        # cidr_block=someIpRange
        # available_ip_address_count=someInt
        # tagset=nil
        # >
        #

        def get(subnet_id)
          if subnet_id
            self.class.new(:connection => connection).all('subnet-id' => subnet_id).first
          end
        end

      end

    end
  end
end
