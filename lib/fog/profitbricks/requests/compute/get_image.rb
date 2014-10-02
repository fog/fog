module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/get_image'

                # Displays a list of all available images.
                #
                # ==== Parameters
                # * imageId<~String> - Name of the new virtual data center
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * getAllImagesResponse<~Hash>:
                #       * imageId<~String> - Identifer of the image
                #       * imageName<~String> - Name of the image
                #       * imageSize<~Integer> - Size of the image (in MB?)
                #       * imageType<~String> - Image type HDD or CD-ROM/DVD (ISO) image
                #       * writeable<~String> - Image is writable (TRUE/FALSE)
                #       * bootable<~String> - Image is bootable
                #       * cpuHotplug<~String> -Image supports CPU Hot-Plugging
                #       * cpuHotUnplug<~String> -
                #       * ramHotPlug<~String> - Image supports memory Hot-Plugging
                #       * ramHotUnPlug<~String> -
                #       * discVirtioHotPlug<~String> -
                #       * discVirtioHotUnplug<~String> -
                #       * nicHotPlug<~String> -
                #       * nicHotUnplug<~String> -
                #       * serverIds<~String> - List all servers by ID on which the image is used
                #       * location<~String> - Location where the image has been uploaded
                #       * osType<~String> - OS type of an image (WINDOWS, LINUX, OTHER, UNKNOWN)
                #       * public<~String> - Shows if image is publicly available or private
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/APIDocumentation.html?GetImages.html]
                def get_image(image_id)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].getImage {
                        xml.imageId(image_id)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::GetImage.new
                    )
                rescue Excon::Errors::InternalServerError => error
                    Fog::Errors::NotFound.new(error)
                end
            end

            class Mock
                def get_image(image_id)
                    if data_center = self.data[:images].find {
                      |attrib| attrib['imageId'] == image_id
                    }
                    else
                        raise Fog::Errors::NotFound.new('The requested resource could not be found')
                    end

                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = { 'getImageResponse' => data_center }
                    response
                end
            end
        end
    end
end
