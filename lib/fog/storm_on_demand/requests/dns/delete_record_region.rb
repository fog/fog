module Fog
  module DNS
    class StormOnDemand
      class Real
        def delete_record_region(options={})
          request(
            :path => '/Network/DNS/Record/Region/delete',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
