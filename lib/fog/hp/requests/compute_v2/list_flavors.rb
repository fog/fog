module Fog
  module Compute
    class HPV2
      class Real
        # List all flavors (IDs and names only)
        #
        # ==== Parameters
        # * options<~Hash>: filter options
        #   * 'minDisk'<~Integer> - Filters the list of flavors to those with the specified minimum number of gigabytes of disk storage.
        #   * 'minRam'<~Integer> - Filters the list of flavors to those with the specified minimum amount of RAM in megabytes.
        #   * 'marker'<~String> - The ID of the last item in the previous list
        #   * 'limit'<~Integer> - Sets the page size
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'id'<~String> - UUId of the flavor
        #     * 'name'<~String> - Name of the flavor
        #     * 'links'<~Array> - array of flavor links
        def list_flavors(options = {})
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'flavors',
            :query    => options
          )
        end
      end

      class Mock
        def list_flavors
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'flavors' => [
              { 'name' => 'standard.xsmall',   'id' => '1', 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/1", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/1", "rel"=>"bookmark"}] },
              { 'name' => 'standard.small',    'id' => '2', 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/2", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/2", "rel"=>"bookmark"}] },
              { 'name' => 'standard.medium',   'id' => '3', 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/3", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/3", "rel"=>"bookmark"}] },
              { 'name' => 'standard.large',    'id' => '4', 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/4", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/4", "rel"=>"bookmark"}] },
              { 'name' => 'standard.xlarge',   'id' => '5', 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/5", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/5", "rel"=>"bookmark"}] },
              { 'name' => 'standard.2xlarge',  'id' => '6', 'links' => [{"href"=>"http://nova1:8774/v1.1/admin/flavors/6", "rel"=>"self"}, {"href"=>"http://nova1:8774admin/flavors/6", "rel"=>"bookmark"}] }
            ]
          }
          response
        end
      end
    end
  end
end
