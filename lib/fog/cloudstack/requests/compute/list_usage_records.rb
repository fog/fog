module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists usage records for accounts
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listUsageRecords.html]
        def list_usage_records(options={})
          options.merge!(
            'command' => 'listUsageRecords', 
            'startdate' => options['startdate'], 
            'enddate' => options['enddate']  
          )
          request(options)
        end
      end

    end
  end
end

