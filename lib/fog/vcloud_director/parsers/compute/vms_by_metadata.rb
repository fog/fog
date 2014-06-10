module Fog
  module Parsers
    module Compute
      module VcloudDirector
        class VmsByMetadata < VcloudDirectorParser
          def reset
            @response = { :vm_records => [] }
          end

          def start_element(name, attributes)
            super
            case name
            when 'QueryResultRecords'
              results = extract_attributes(attributes)
              @response[:type] = results[:type]
              @response[:href] = results[:href]
              @response[:total] = results[:total].to_i
              # href "https://devlab.mdsol.com/api/vms/query?page=1&amp;pageSize=25&amp;format=records&amp;filter=metadata:unoo==STRING:janderr&amp;fields=name,containerName"
              key = @response[:href].scan(/filter=metadata:(.*)==STRING/).flatten.first
              value = @response[:href].scan(/STRING:(.*)&?/).flatten.first
              @response[:id] = "#{key}:#{value}"
            when 'VMRecord'
              results = extract_attributes(attributes)
              results[:id] = results[:href].split('/').last
              results[:vapp_name] = results.delete(:containerName)
              results[:vapp_id] = results.delete(:container).split('/').last
              results[:cpu] = results.delete(:numberOfCpus)
              results[:memory] = results.delete(:memoryMB)
              results[:type] = "application/vnd.vmware.vcloud.vm+xml"
              @response[:vm_records] << results
            end
          end
        end
      end
    end
  end
end
