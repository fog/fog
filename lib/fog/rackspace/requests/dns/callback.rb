module Fog
  module DNS
    class Rackspace
      class Real
        def callback(job_id)

          validate_path_fragment :job_id, job_id

          request(
            :expects  => [200, 202, 204],
            :method   => 'GET',
            :path     => "status/#{job_id}"
          )
        end
      end
    end
  end
end
