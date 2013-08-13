module Fog
  module Parsers
    module Compute
      module AWS

        class DescribeRouteTables < Fog::Parsers::Base

          def reset
            @association = {}
            @in_association_set = false
            @in_route_set = false
            @route = {}
            @response = { 'routeTableSet' => [] }
            @tag = {}
            @route_table = { 'associationSet' => [], 'tagSet' => {}, 'routeSet' => [] }
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'associationSet'
              @in_association_set = true
            when 'tagSet'
              @in_tag_set = true
            when 'routeSet'
              @in_route_set = true
            end
          end

          def end_element(name)
            if @in_association_set
              case name
              when 'associationSet'
                @in_association_set = false
              when 'routeTableAssociationId', 'routeTableId', 'subnetId', 'main'
                @association[name] = value
              when 'item'
                @route_table['associationSet'] << @association
                @association = {}
              end
            elsif @in_tag_set
              case name
              when 'key', 'value'
                @tag[name] = value
              when 'item'
                @route_table['tagSet'][@tag['key']] = @tag['value']
                @tag = {}
              when 'tagSet'
                @in_tag_set = false
              end
            elsif @in_route_set
              case name
              when 'destinationCidrBlock', 'gatewayId', 'state'
                @route[name] = value
              when 'item'
                @route_table['routeSet'] << @route
                @route = {}
              when 'routeSet'
                @in_route_set = false
              end
            else
              case name
              when 'routeTableId', 'vpcId'
                @route_table[name] = value
              when 'item'
                @response['routeTableSet'] << @route_table
                @route_table = { 'associationSet' => [], 'tagSet' => {}, 'routeSet' => [] }
              when 'requestId'
                @response[name] = value
              end
            end
          end

        end

      end
    end
  end
end
