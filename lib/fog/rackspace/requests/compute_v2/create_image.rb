module Fog
  module Compute
    class RackspaceV2
      class Real
        def create_image(server_id, name, options={})
          data = {
            'createImage' => {
              'name' => name,
              'metadata' => {}
            }  
          }
          
          data['createImage']['metadata']['ImageType'] = options[:image_type] unless options[:image_type].nil?
          data['createImage']['metadata']['ImageVersion'] = options[:image_version] unless options[:image_version].nil?

          request(
            :body => Fog::JSON.encode(data),
            :expects => [202],
            :method => 'POST',
            :path => "servers/#{server_id}/action"
          )
        end  
      end
    end
  end
end
