module Fog
  module Compute
    class HPV2
      class Real
        # List all flavors
        #
        # ==== Parameters
        # * options<~Hash>: filter options
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'id'<~String> - UUId of the flavor
        #     * 'name'<~String> - Name of the flavor
        #     * 'ram'<~Integer> - Amount of ram for the flavor
        #     * 'vcpus'<~Integer> - Virtual CPUs for the flavor
        #     * 'disk'<~Integer> - Amount of diskspace for the flavor
        #     * 'OS-FLV-EXT-DATA:ephemeral'<~Integer> - Amount of ephemeral diskspace for the flavor
        #     * 'links'<~Array> - array of flavor links
        def list_flavors_detail(options = {})
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'flavors/detail',
            :query    => options
          )
        end
      end

      class Mock
        def list_flavors_detail(options = {})
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'flavors' => [
              { 'name' => 'standard.xsmall',  'ram' => 1024,    'disk' => 30,   'id' => '1', 'OS-FLV-EXT-DATA:ephemeral' => 20, 'vcpus' => 1, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/1", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/1", "rel"=>"bookmark"}] },
              { 'name' => 'standard.small',   'ram' => 2048,    'disk' => 60,   'id' => '2', 'OS-FLV-EXT-DATA:ephemeral' => 20, 'vcpus' => 2, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/2", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/2", "rel"=>"bookmark"}] },
              { 'name' => 'standard.medium',  'ram' => 4096,    'disk' => 120,  'id' => '3', 'OS-FLV-EXT-DATA:ephemeral' => 20, 'vcpus' => 2, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/3", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/3", "rel"=>"bookmark"}] },
              { 'name' => 'standard.large',   'ram' => 8192,    'disk' => 240,  'id' => '4', 'OS-FLV-EXT-DATA:ephemeral' => 20, 'vcpus' => 4, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/4", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/4", "rel"=>"bookmark"}] },
              { 'name' => 'standard.xlarge',  'ram' => 16384,   'disk' => 480,  'id' => '5', 'OS-FLV-EXT-DATA:ephemeral' => 20, 'vcpus' => 4, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/5", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/5", "rel"=>"bookmark"}] },
              { 'name' => 'standard.2xlarge', 'ram' => 32768,   'disk' => 960,  'id' => '6', 'OS-FLV-EXT-DATA:ephemeral' => 20, 'vcpus' => 8, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/6", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/6", "rel"=>"bookmark"}] }
            ]
          }
          response
        end
      end
    end
  end
end
