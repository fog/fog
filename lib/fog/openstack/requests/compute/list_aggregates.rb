module Fog
  module Compute
    class OpenStack
      class Real
        def list_aggregates(parameters=nil)
          if parameters
            query = parameters.each { |k, v| parameters[k] = URI::encode(v) }
          else
            query = {}
          end

          request(
            :expects => [200, 203],
            :method  => 'GET',
            :path    => 'os-aggregates',
            :query   => query
          )
        end
      end

      class Mock
        def list_aggregates(parameters=nil)
          response = Excon::Response.new
          response.status = 200
          response.body = {'aggregates' => [{
            "availability_zone" => "nova",
            "created_at" => "2012-11-16T06:22:23.032493",
            "deleted" => false,
            "deleted_at" => nil,
            "metadata" => {
              "availability_zone" => "nova" },
            "id" => 1,
            "name" => "name",
            "updated_at" => nil
          }]}

          response
        end
      end # mock
    end # openstack
  end # compute
end # fog
