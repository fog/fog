module Fog
  module DNS
    class StormOnDemand
      class Real

        def delete_record(options={})
          request(
            :path => '/Network/DNS/Record/delete',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
