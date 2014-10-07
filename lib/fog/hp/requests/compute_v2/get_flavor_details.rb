module Fog
  module Compute
    class HPV2
      class Real
        # Get details for flavor by id
        #
        # ==== Parameters
        # * 'flavor_id'<~String> - UUId of the flavor to get details for
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
        def get_flavor_details(flavor_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "flavors/#{flavor_id}"
          )
        end
      end

      class Mock
        def get_flavor_details(flavor_id)
          response = Excon::Response.new
          flavor = {
            '1' => { 'name' => 'standard.xsmall',  'ram' => 1024,    'disk' => 30,   'id' => '1', 'OS-FLV-EXT-DATA:ephemeral' => 20, 'vcpus' => 1, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/1", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/1", "rel"=>"bookmark"}] },
            '2' => { 'name' => 'standard.small',   'ram' => 2048,    'disk' => 60,   'id' => '2', 'OS-FLV-EXT-DATA:ephemeral' => 20, 'vcpus' => 2, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/2", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/2", "rel"=>"bookmark"}] },
            '3' => { 'name' => 'standard.medium',  'ram' => 4096,    'disk' => 120,  'id' => '3', 'OS-FLV-EXT-DATA:ephemeral' => 20, 'vcpus' => 2, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/3", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/3", "rel"=>"bookmark"}] },
            '4' => { 'name' => 'standard.large',   'ram' => 8192,    'disk' => 240,  'id' => '4', 'OS-FLV-EXT-DATA:ephemeral' => 20, 'vcpus' => 4, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/4", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/4", "rel"=>"bookmark"}] },
            '5' => { 'name' => 'standard.xlarge',  'ram' => 16384,   'disk' => 480,  'id' => '5', 'OS-FLV-EXT-DATA:ephemeral' => 20, 'vcpus' => 4, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/5", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/5", "rel"=>"bookmark"}] },
            '6' => { 'name' => 'standard.2xlarge', 'ram' => 32768,   'disk' => 960,  'id' => '6', 'OS-FLV-EXT-DATA:ephemeral' => 20, 'vcpus' => 8, 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/6", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/6", "rel"=>"bookmark"}] }
          }[flavor_id]
          if flavor
            response.status = 200
            response.body = {
              'flavor' => flavor
            }
            response
          else
            raise Fog::Compute::HPV2::NotFound
          end
        end
      end
    end
  end
end
