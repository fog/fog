module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/get_all_images'
                #
                # Displays a list of all available images.
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/APIDocumentation.html?GetAllImages.html]
                #
                # ==== Parameters
                # N/A
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * getAllImagesResponse<~Hash>:
                #       * imageId<~String> - Identifer of the image
                #       * imageName<~String> - Name of the image
                #       * imageSize<~Integer> - Size of the image
                #       * imageType<~String> - Image type HDD or CD-ROM/DVD (ISO) image
                #       * writeable<~String> - Image is writable (TRUE/FALSE)
                #       * cpuHotpluggable<~String> - Image supports CPU Hot-Plugging
                #       * memoryHotpluggable<~String> - Image supports memory Hot-Plugging
                #       * serverIds<~String> - List all servers by ID on which the image is used
                #       * region<~String> - Region where the image has been uploaded
                #       * osType<~String> - OS type of an image (WINDOWS, LINUX, OTHER, UNKNOWN)
                #       * public<~String> - Shows if image is publicly available or private
                #
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
                def get_all_images()
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