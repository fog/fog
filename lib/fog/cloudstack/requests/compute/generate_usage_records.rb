module Fog
  module Compute
    class Cloudstack

      class Real
        # Generates usage records. This will generate records only if there any records to be generated, i.e if the scheduled usage job was not run or failed
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/generateUsageRecords.html]
        def generate_usage_records(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'generateUsageRecords') 
          else
            options.merge!('command' => 'generateUsageRecords', 
            'enddate' => args[0], 
            'startdate' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

