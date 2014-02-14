  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Generates usage records. This will generate records only if there any records to be generated, i.e if the scheduled usage job was not run or failed
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/generateUsageRecords.html]
          def generate_usage_records(options={})
            options.merge!(
              'command' => 'generateUsageRecords'
            )

            if startdate = options.delete('startdate')
              options.merge!('startdate' => startdate.strftime('%Y-%m-%d'))
            end
            
            if enddate = options.delete('enddate')
              options.merge!('enddate' => enddate.strftime('%Y-%m-%d'))
            end
            
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
