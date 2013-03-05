module Fog
  module HP
    class LB
      class Real

        # Get details for existing database flavor instance
        #
        # ==== Parameters
        # * flavor_id<~Integer> - Id of the flavor to get
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * TBD

        def get_version(version_id)
          response = request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/#{version_id}/",
            :version => true
          )
          response
        end

      end

      class Mock # :nodoc:all

        def get_version(version_id)
          unless version_id
            raise ArgumentError.new('version_id is required')
          end
          response = Excon::Response.new
          if version = list_versions.body['versions'].detect { |_| _['id'] == version_id }
            response.status = 200
            response.body   = {'version' => version}
            response
          else
            raise Fog::HP::LB::NotFound
          end

        end
      end
    end
  end
end