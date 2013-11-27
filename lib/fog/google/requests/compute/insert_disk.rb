module Fog
  module Compute
    class Google

      class Mock

        def insert_disk(disk_name, zone_name, image_name=nil, options={})
          # check that image and zone exist
          image_project = nil
          unless image_name.nil?
            ([ @project ] + Fog::Compute::Google::Images::GLOBAL_PROJECTS).each do |project|
              image_project = project
              break if data(project)[:images][options['image']]
            end
            get_image(image_name, image_project) # ok if image exists, will fail otherwise
          end
          get_zone(zone_name)

          self.data[:disks][disk_name] = {
            "kind" => "compute#disk",
            "id" => Fog::Mock.random_numbers(19),
            "creationTimestamp" => Time.now.iso8601,
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}",
            "status" => "READY",
            "name" => disk_name,
            "sizeGb" => options['sizeGb'] || "10",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/disks/#{disk_name}"
          }

          build_response(:body => {
            "kind" => "compute#operation",
            "id" => "12498846269172327286",
            "name" => "operation-1385124218076-4ebc35cfbe9f1-476486c5",
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}",
            "operationType" => "insert",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/disks/#{disk_name}",
            "status" => "PENDING",
            "user" => "123456789012-qwertyuiopasdfghjkl1234567890qwe@developer.gserviceaccount.com",
            "progress" => 0,
            "insertTime" => Time.now.iso8601,
            "startTime" => Time.now.iso8601,
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/operations/operation-1385124218076-4ebc35cfbe9f1-476486c5"
          })
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
