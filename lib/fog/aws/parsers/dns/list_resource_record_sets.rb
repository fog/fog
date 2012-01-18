module Fog
  module Parsers
    module DNS
      module AWS

        class ListResourceRecordSets < Fog::Parsers::Base

          def reset
            @resource_record = []
            @resource_record_set = {}
            @resource_record_set['ResourceRecords'] = []
            @response = {}
            @response['ResourceRecordSets'] = []
            @section = :resource_record_set
          end
          
          def end_element(name)
            if @section == :resource_record_set
              case name
              when 'Name', 'Type', 'TTL'
                @resource_record_set[name] = value
              when 'Value'
                @resource_record_set['ResourceRecords'] << value
              when 'ResourceRecordSet'
                @response['ResourceRecordSets'] << @resource_record_set
                @resource_record_set = {}
                @resource_record_set['ResourceRecords'] = []
              when 'ResourceRecordSets'
                @section = :main
              end
            elsif @section == :main
                case name
                when 'MaxItems'
                  @response[name]= value.to_i
                when 'IsTruncated', 'NextRecordName', 'NextRecordType'
                  @response[name]= value
                end
            end
          end

        end

      end
    end
  end
end
