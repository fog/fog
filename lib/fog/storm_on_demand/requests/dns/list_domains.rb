module Fog
  module DNS
    class StormOnDemand
      class Real
        def list_domains(options={})
          request(
            :path => '/Network/DNS/Domain/list',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
