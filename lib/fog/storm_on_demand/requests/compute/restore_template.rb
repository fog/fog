module Fog
  module Compute
    class StormOnDemand
      class Real

        def restore_template(options={})
          request(
            :path => '/Storm/Template/restore',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
