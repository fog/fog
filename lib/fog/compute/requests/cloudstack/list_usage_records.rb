module Fog
  module Compute
    class Cloudstack
      class Real

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
