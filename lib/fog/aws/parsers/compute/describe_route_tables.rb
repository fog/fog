module Fog
  module Parsers
    module Compute
      module AWS

        class DescribeRouteTables < Fog::Parsers::Base

          def reset
            @route_table = { 'tagSet' => {}, 'routeSet' => {}, 'associationSet' => {}, 'propagatingVgwSet' => {} }
            @response = { 'routeTableSet' => [] }
            @tag = {}
            @route ={}
            @association = {}
            @propagating_vgw = {}
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'tagSet'
              @in_tag_set = true
            when 'routeSet'
              @in_route_set = true
            when 'associationSet'
              @in_association_set = true
            when 'propagatingVgwSet'
              @in_propagating_vgw_set = true
            end
          end

          def end_element(name)
            if @in_tag_set
              case name
                when 'item'
                  @vpc['tagSet'][@tag['key']] = @tag['value']
                  @tag = {}
                when 'key', 'value'
                  @tag[name] = value
                when 'tagSet'
                  @in_tag_set = false
              end
            elsif @in_association_set
              case name
                when 'item'
                  @route_table['associationSet']=@association
                  @association = {}
                when 'routeTableAssociationId', 'routeTableId', 'main'
                  @association[name] = value
                when 'associationSet'
                  @in_association_set = false
              end
            elsif @in_route_set
              case name
                when 'item'
                  @route_table['routeSet']=@route
                  @route = {}
                when 'destinationCidrBlock', 'gatewayId', 'state', 'origin'
                  @route[name] = value
                when 'routeSet'
                  @in_route_set = false
              end
            elsif @in_propagating_vgw_set
              case name
                when 'item'
                  @route_table['propagatingVgwSet']=@propagating_vgw
                  @propagating_vgw = {}
                when 'gatewayId'
                  @propagating_vgw[name] = value
                when 'propagatingVgwSet'
                  @in_propagating_vgw_set = false
              end
            else
              case name
              when 'routeTableId'
                @route_table[name] = value
              when 'item'
                @response['routeTableSet'] << @route_table
                @route_table = { 'tagSet' => {}, 'routeSet' => {}, 'associationSet' => {}, 'propagatingVgwSet' => {} }
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


