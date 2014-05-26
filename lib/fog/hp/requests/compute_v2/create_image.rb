module Fog
  module Compute
    class HPV2
      class Real
        # Create an image from an existing server
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of server to create the image from
        # * 'name'<~String> - Name of the image
        # * 'metadata'<~Hash> - A hash of metadata options
        #
        # ==== Returns
        # Does not return a response body.
        def create_image(server_id, name, metadata = {})
          body = { 'createImage' =>
                   { 'name' => name,
                     'metadata' => metadata
                   }
                 }
          server_action(server_id, body)
        end
      end

      class Mock
        def create_image(server_id, name, metadata = {})
          response = Excon::Response.new
          if list_servers_detail.body['servers'].find {|_| _['id'] == server_id}
            response.status = 202

            image_id = Fog::HP::Mock.uuid.to_s

            data = {
              'id'        => image_id,
              'server'    => {"id"=>server_id, "links"=>[{"href"=>"http://nova1:8774/v1.1/servers/#{server_id}", "rel"=>"bookmark"}]},
              'links'     => [{"href"=>"http://nova1:8774/v1.1/tenantid/images/#{image_id}", "rel"=>"self"}, {"href"=>"http://nova1:8774/tenantid/images/#{image_id}", "rel"=>"bookmark"}],
              'metadata'  => metadata || {},
              'name'      => name || "image_#{rand(999)}",
              'progress'  => 0,
              'minDisk'   => 0,
              'minRam'    => 0,
              'status'    => 'SAVING',
              'updated'   => "2012-01-01T13:32:20Z",
              'created'   => "2012-01-01T13:32:20Z"
            }

            self.data[:last_modified][:images][data['id']] = Time.now
            self.data[:images][data['id']] = data
            response.headers = {'Content-Length' => '0', 'Content-Type' => 'text/html; charset=UTF-8', 'Date' => Time.now, 'Location' => "http://nova1:8774/v1.1/images/#{image_id}"}
            response.body = '' # { 'image' => data } no data is returned
            response
          else
            raise Fog::Compute::HPV2::NotFound
          end
        end
      end
    end
  end
end
