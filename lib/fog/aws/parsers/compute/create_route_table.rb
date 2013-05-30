module Fog
  module Parsers
    module Compute
      module AWS

        class CreateRouteTable < Fog::Parsers::Base

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
                  @route_table['tagSet'][@tag['key']] = @tag['value']
                  @tag = {}
                when 'key', 'value'
                  @tag[name] = value
                when 'tagSet'
                  @in_tag_set = false
              end
            elsif @in_association_set
              case name
                when 'item'
                  @route_table['associationSet'][@association['key']] = @association['value']
                  @association = {}
                when 'key', 'value'
                  @association[name] = value
                when 'attachmentSet'
                  @in_association_set = false
              end
            elsif @in_route_set
              case name
                when 'item'
                  @route_table['routeSet'][@route['key']] = @route['value']
                  @route = {}
                when 'key', 'value'
                  @route[name] = value
                when 'routeSet'
                  @in_route_set = false
              end
            elsif @in_propagating_vgw_set
              case name
                when 'item'
                  @route_table['propagatingVgwSet'][@propagating_vgw['key']] = @propagating_vgw['value']
                  @propagating_vgw = {}
                when 'key', 'value'
                  @propagating_vgw[name] = value
                when 'attachmentSet'
                  @in_propagating_vgw_set = false
              end      
            else
              case name
              when 'routeTableId', 'vpcId'
                @route_table[name] = value
              when 'routeTable'
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


