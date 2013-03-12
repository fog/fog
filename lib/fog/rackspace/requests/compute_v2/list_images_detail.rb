module Fog
  module Compute
    class RackspaceV2
      class Real
        def list_images_detail(options={})
        
          if options[:type] != nil 
             path = "images/detail?type=#{options[:type]}"
          else
             path = "images/detail"
          end
        
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => "#{path}"
          )
        end
      end
    class Mock
        def list_images_details
          images = self.data[:images].values
          response(:body => {"images" => images})
        end
      end  
    end
  end
end
