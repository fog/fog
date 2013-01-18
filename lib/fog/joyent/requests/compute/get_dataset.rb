module Fog
  module Compute
    class Joyent

      class Mock
        def get_dataset(id)
          if ds = self.data[:datasets][id]
            res = Excon::Response.new
            res.status = 200
            res.body = ds
          else
            raise Excon::Errors::NotFound
          end
        end
      end

      class Real
        def get_dataset
          request(
            :method => "GET",
            :path => "/my/datasets"
          )
        end
      end

    end
  end
end
