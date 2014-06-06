module Fog
  module Compute
    class HP
      class Real
        # Create an image from an existing server
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to create image from
        # * name<~String> - Name of the image
        # * metadata<~Hash> - A hash of metadata options
        #   * 'ImageType'<~String> - type of the image i.e. Gold
        #   * 'ImageVersion'<~String> - version of the image i.e. 2.0
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
          response.status = 202

          image_id = Fog::Mock.random_numbers(6).to_s

          data = {
            'id'        => image_id,
            'server'    => {"id"=>server_id, "links"=>[{"href"=>"http://nova1:8774/v1.1/servers/#{server_id}", "rel"=>"bookmark"}]},
            'links'     => [{"href"=>"http://nova1:8774/v1.1/tenantid/images/#{image_id}", "rel"=>"self"}, {"href"=>"http://nova1:8774/tenantid/images/#{image_id}", "rel"=>"bookmark"}],
            'metadata'  => metadata || {},
            'name'      => name || "image_#{rand(999)}",
            'progress'  => 0,
            'status'    => 'SAVING',
            'updated'   => "2012-01-01T13:32:20Z",
            'created'   => "2012-01-01T13:32:20Z"
          }

          self.data[:last_modified][:images][data['id']] = Time.now
          self.data[:images][data['id']] = data
          response.headers = {'Content-Length' => '0', 'Content-Type' => 'text/html; charset=UTF-8', 'Date' => Time.now, 'Location' => "http://nova1:8774/v1.1/images/#{image_id}"}
          response.body = "" # { 'image' => data } no data is sent
          response
        end
      end
    end
  end
end
