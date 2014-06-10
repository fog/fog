module Fog
  module Compute
    class HP
      class Real
        # List all flavors
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'id'<~Integer> - Id of the flavor
        #     * 'name'<~String> - Name of the flavor
        #     * 'ram'<~Integer> - Amount of ram for the flavor
        #     * 'disk'<~Integer> - Amount of diskspace for the flavor
        def list_flavors_detail
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'flavors/detail.json'
          )
        end
      end

      class Mock
        def list_flavors_detail
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'flavors' => [
              { 'name' => 'standard.xsmall',  'ram' => 1024,    'disk' => 30,   'id' => 1, 'rxtx_quota' => 0, 'vcpus' => 1, 'rxtx_cap' => 0, 'swap' => 0, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/1", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/1", "rel"=>"bookmark"}] },
              { 'name' => 'standard.small',   'ram' => 2048,    'disk' => 60,   'id' => 2, 'rxtx_quota' => 0, 'vcpus' => 2, 'rxtx_cap' => 0, 'swap' => 0, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/2", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/2", "rel"=>"bookmark"}] },
              { 'name' => 'standard.medium',  'ram' => 4096,    'disk' => 120,  'id' => 3, 'rxtx_quota' => 0, 'vcpus' => 2, 'rxtx_cap' => 0, 'swap' => 0, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/3", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/3", "rel"=>"bookmark"}] },
              { 'name' => 'standard.large',   'ram' => 8192,    'disk' => 240,  'id' => 4, 'rxtx_quota' => 0, 'vcpus' => 4, 'rxtx_cap' => 0, 'swap' => 0, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/4", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/4", "rel"=>"bookmark"}] },
              { 'name' => 'standard.xlarge',  'ram' => 16384,   'disk' => 480,  'id' => 5, 'rxtx_quota' => 0, 'vcpus' => 4, 'rxtx_cap' => 0, 'swap' => 0, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/5", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/5", "rel"=>"bookmark"}] },
              { 'name' => 'standard.2xlarge', 'ram' => 32768,   'disk' => 960,  'id' => 6, 'rxtx_quota' => 0, 'vcpus' => 8, 'rxtx_cap' => 0, 'swap' => 0, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/6", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/6", "rel"=>"bookmark"}] }
            ]
          }
          response
        end
      end
    end
  end
end
