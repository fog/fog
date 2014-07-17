module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/get_all_images'
                def get_all_images()
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].getAllImages
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::GetAllImages.new
                    )
                end
            end

            class Mock
                def get_all_images(options = {})
                    if data = self.data[:images]
                        response        = Excon::Response.new
                        response.status = 200
                        response.body   = {
                          'getAllImagesResponse' => self.data[:images]
                        }
                        response
                    else
                        raise Fog::Compute::NotFound
                    end
                end
            end
        end
    end
end