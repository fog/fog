module Fog
  module Compute
    class Cloudstack

      class Real
        # Generates usage records. This will generate records only if there any records to be generated, i.e if the scheduled usage job was not run or failed
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/generateUsageRecords.html]
        def generate_usage_records(enddate, startdate, options={})
          options.merge!(
            'command' => 'generateUsageRecords', 
            'enddate' => enddate, 
            'startdate' => startdate  
          )
          request(options)
        end
      end

    end
  end
end

