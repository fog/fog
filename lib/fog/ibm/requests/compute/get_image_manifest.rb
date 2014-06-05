module Fog
  module Compute
    class IBM
      class Real
        # Returns manifest of image specified by id
        #
        # ==== Parameters
        # 'image_id'<~String>: id of desired image
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'manifest'<~String>: manifest of image in xml
        def get_image_manifest(image_id)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/offerings/image/#{image_id}/manifest"
          )
        end
      end

      class Mock
        # TODO: Create a data store for this.
        def get_image_manifest(image_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {"manifest"=>
              "<?xml version=\"1.0\" encoding=\"UTF-8\"?><parameters xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"platform:/resource/com.ibm.ccl.devcloud.client/schema/parameters.xsd\">\n\t<firewall>\n\t\t<rule>\n\t\t\t<source>0.0.0.0/0</source>\n\t\t\t<minport>1</minport>\n\t\t\t<maxport>65535</maxport>\n\t\t</rule>\n\t</firewall>\n</parameters>"}
          response
        end
      end
    end
  end
end
