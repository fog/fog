module Fog
  module Compute
    class Clodo
      class Real

        # List all images
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'os_type'<~String> - OS distribution
        #     * 'os_bits'<~Integer> - OS bits
        #     * 'os_hvm'<~Integer> - HVM flag
	#     * '_attr'<~Hash>:
        #      * 'id'<~Integer> - Id of the image
        #      * 'name'<~String> - Name of the image
        #      * 'status'<~String> - Status of the image
        #      * 'vps_type'<~String> - VirtualServer or ScaleServer

        def list_images_detail
          request(
                  :expects  => [200, 203],
                  :method   => 'GET',
                  :path     => 'images/detail'
                  )
        end

      end

      class Mock

        def list_images_detail
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'images' => [{ 'os_type' => 'debian',
                           'os_bits' => "64",
                           'os_hvm' => "0",
                           '_attr' => {
                             'id' => "541",
                             'name' => 'Debian 6 64 bits',
                             'status' => 'ACTIVE',
                             'vps_type' => 'ScaleServer'
                           }},
                         { 'os_type' => 'centos',
                           'os_bits' => "32",
                           'os_hvm' => "0",
                           '_attr' => {
                             'name' => 'CentOS 5.5 32 bits',
                             'id' => "31",
                             'vps_type' => 'VirtualServer',
                             'status' => 'ACTIVE',
                           }}]
          }
          response
        end

      end
    end
  end
end
