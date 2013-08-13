module Fog
  module Compute
    class Google

      class Mock

        def insert_disk(disk_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def insert_disk(disk_name, zone_name, image_name=nil, opts={})
          api_method = @compute.disks.insert
          parameters = {
            'project' => @project,
            'zone' => zone_name
          }

          if image_name
            image = images.get(image_name)
            raise ArgumentError.new('Invalid image specified') unless image
            @image_url = @api_url + image.resource_url
            parameters['sourceImage'] = @image_url
          end

          body_object = { 'name' => disk_name }

          # These must be present if image_name is not specified
          if image_name.nil?
            unless opts.has_key?('sourceSnapshot') and opts.has_key?('sizeGb')
              raise ArgumentError.new('Must specify image OR snapshot and '\
                                      'disk size when creating a disk.')
            end

            body_object['sizeGb'] = opts.delete('sizeGb')

            snap = snapshots.get(opts.delete('sourceSnapshot'))
            raise ArgumentError.new('Invalid source snapshot') unless snap
            body_object['sourceSnapshot'] = @api_url + snap.resource_url
          end

          # Merge in any remaining options (only 'description' should remain)
          body_object.merge(opts)

          result = self.build_result(api_method, parameters,
                                     body_object)
          response = self.build_response(result)
        end

      end

    end
  end
end
