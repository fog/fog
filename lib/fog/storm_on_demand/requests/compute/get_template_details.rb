module Fog
  module Compute
    class StormOnDemand
      class Real

        def get_template_details(options={})
          request(
            :path => '/Storm/Template/details',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
