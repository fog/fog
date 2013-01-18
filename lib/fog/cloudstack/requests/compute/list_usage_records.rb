module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists usage records for accounts.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listUsageRecords.html]
        def list_usage_records(options={})
          options.merge!(
            'command' => 'listUsageRecords'
          )
          
          if startdate = options.delete('startdate')
            options.merge!('startdate' => startdate.strftime('%Y-%m-%d'))
          end
          
          if enddate = options.delete('enddate')
            options.merge!('enddate' => enddate.strftime('%Y-%m-%d'))
          end
          
          request(options)
        end

      end
    end
  end
end
