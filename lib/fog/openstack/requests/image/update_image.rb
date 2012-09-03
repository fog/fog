module Fog
  module Image
    class OpenStack
      class Real

        def update_image(attributes)

         data = {
              "x-image-meta-name" => attributes[:name],
              "x-image-meta-disk-format" => attributes[:disk_format],
              "x-image-meta-container-format" => attributes[:container_format],
              "x-image-meta-size" => attributes[:size],
              "x-image-meta-is-public" => attributes[:is_public],
              "x-image-meta-min-ram"  => attributes[:min_ram],
              "x-image-meta-min-disk" => attributes[:min_disk],
              "x-image-meta-checksum" => attributes[:checksum],
              "x-image-meta-owner" => attributes[:owner]
          }

          unless attributes[:properties].nil?
            attributes[:properties].each do |key,value|
              data["x-image-meta-property-#{key}"] = value
            end
          end

          request(
            :headers  => data,
            :expects  => 200,
            :method   => 'PUT',
            :path     => "images/#{attributes[:id]}"
          )
        end

      end

      class Mock

        def update_image(attributes)
          response = Excon::Response.new
          response.status = 200
          response.body = {
                            'image'=> {
                              'name'             => attributes[:name],
                              'size'             => Fog::Mock.random_numbers(8).to_i,
                              'min_disk'         => 0,
                              'disk_format'      => 'iso',
                              'created_at'       => Time.now.to_s,
                              'container_format' => 'bare',
                              'deleted_at'       => nil,
                              'updated_at'       => Time.now.to_s,
                              'checksum'         => Fog::Mock.random_hex(32),
                              'id'               => attributes[:id],
                              'deleted'          => false,
                              'protected'        => false,
                              'is_public'        => false,
                              'status'           => 'queued',
                              'min_ram'          => 0,
                              'owner'            => Fog::Mock.random_hex(32),
                              'properties'       => {}
                            }
                          }
          response

        end

      end
    end
  end
end
