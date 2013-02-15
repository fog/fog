module Fog
  module Image
    class OpenStack
      class Real

        def create_image(attributes)
          data = {
            'Content-Type'=>'application/octet-stream',
            'x-image-meta-name' => attributes[:name],
            'x-image-meta-disk-format' => attributes[:disk_format],
            'x-image-meta-container-format' => attributes[:container_format],
            'x-image-meta-size' => attributes[:size],
            'x-image-meta-is-public' => attributes[:is_public],
            'x-image-meta-min-ram'  => attributes[:min_ram],
            'x-image-meta-min-disk' => attributes[:min_disk],
            'x-image-meta-checksum' => attributes[:checksum],
            'x-image-meta-owner' => attributes[:owner],
            'x-glance-api-copy-from' => attributes[:copy_from]
          }.reject { |k,v| v.nil? }

          body = String.new
          if attributes[:location]
            body = File.open(attributes[:location], "rb")
            # Make sure the image file size is always present
            data['x-image-meta-size'] = File.size(body)
          end

          unless attributes[:properties].nil?
            attributes[:properties].each do |key,value|
              data["x-image-meta-property-#{key}"] = value
            end
          end

          request(
            :headers  => data,
            :body     => body,
            :expects  => 201,
            :method   => 'POST',
            :path     => "images"
          )
        ensure
          body.close if body.respond_to?(:close)
        end

      end

      class Mock

        def create_image(attributes)
          response = Excon::Response.new
          response.status = 201

          image_id = Fog::Mock.random_hex(32)
          image = self.data[:images][image_id] = {
            'name'             => attributes['name'] || attributes[:name],
            'size'             => Fog::Mock.random_numbers(8).to_i,
            'min_disk'         => 0,
            'disk_format'      => attributes['disk_format'] || attributes[:disk_format] || 'raw',
            'created_at'       => Time.now.to_s,
            'container_format' => attributes['container_format'] || attributes[:container_format] || 'bare',
            'deleted_at'       => nil,
            'updated_at'       => Time.now.to_s,
            'checksum'         => Fog::Mock.random_hex(32),
            'id'               => image_id,
            'deleted'          => false,
            'protected'        => false,
            'is_public'        => false,
            'status'           => 'queued',
            'min_ram'          => 0,
            'owner'            => attributes['owner'] || attributes[:owner],
            'properties'       => attributes['properties'] || attributes[:properties] || {}
          }
          response.body = { 'image'=> image }
          response
        end
      end
    end
  end
end
