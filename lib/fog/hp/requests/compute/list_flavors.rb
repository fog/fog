module Fog
  module Compute
    class HP
      class Real
        # List all flavors (IDs and names only)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'id'<~Integer> - Id of the flavor
        #     * 'name'<~String> - Name of the flavor
        def list_flavors
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'flavors.json'
          )
        end
      end

      class Mock
        def list_flavors
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'flavors' => [
              { 'name' => 'standard.xsmall',   'id' => 1, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/1", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/1", "rel"=>"bookmark"}] },
              { 'name' => 'standard.small',    'id' => 2, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/2", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/2", "rel"=>"bookmark"}] },
              { 'name' => 'standard.medium',   'id' => 3, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/3", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/3", "rel"=>"bookmark"}] },
              { 'name' => 'standard.large',    'id' => 4, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/4", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/4", "rel"=>"bookmark"}] },
              { 'name' => 'standard.xlarge',   'id' => 5, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/5", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/5", "rel"=>"bookmark"}] },
              { 'name' => 'standard.2xlarge',  'id' => 6, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/6", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/6", "rel"=>"bookmark"}] }
            ]
          }
          response
        end
      end
    end
  end
end
