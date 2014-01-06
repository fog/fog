module Fog
  module Compute
    class Google

      class Mock

        def insert_disk(disk_name, zone_name, image_name=nil, options={})
          # check that image and zone exist
          image = nil
          if image_name
            image = images.get(image_name)
            raise ArgumentError.new("Invalid image specified: #{image_name}") unless image
          end
          get_zone(zone_name)

          id = Fog::Mock.random_numbers(19).to_s
          object = {
            "kind" => "compute#disk",
            "id" => id,
            "creationTimestamp" => Time.now.iso8601,
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}",
            "status" => "READY",
            "name" => disk_name,
            "sizeGb" => options['sizeGb'] || "10",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/disks/#{disk_name}"
          }
          if image
            object.merge({
              "sourceImage" => image.self_link,
              "sourceImageId" => image.id
            })
          end
          self.data[:disks][disk_name] = object

          if image
            object.merge!({
              "sourceImage" => image.self_link,
              "sourceImageId" => image.id
            })
          end
          self.data[:disks][disk_name] = object

          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "zone" => object["zone"],
            "operationType" => "insert",
            "targetLink" => object["selfLink"],
            "targetId" => id,
            "status" => Fog::Compute::Google::Operation::PENDING_STATE,
            "user" => "123456789012-qwertyuiopasdfghjkl1234567890qwe@developer.gserviceaccount.com",
            "progress" => 0,
            "insertTime" => Time.now.iso8601,
            "startTime" => Time.now.iso8601,
            "selfLink" => "#{object["zone"]}/operations/#{operation}"
          }

          build_response(:body => self.data[:operations][operation])
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
            # New disk from image
            image = images.get(image_name)
            raise ArgumentError.new("Invalid image specified: #{image_name}") unless image
            @image_url = @api_url + image.resource_url
            parameters['sourceImage'] = @image_url
          end

          body_object = { 'name' => disk_name }

          # According to Google docs, if image name is not present, only one of
          # sizeGb or sourceSnapshot need to be present, one will create blank
          # disk of desired size, other will create disk from snapshot
          if image_name.nil?
            if opts.has_key?('sourceSnapshot')
              # New disk from snapshot
              snap = snapshots.get(opts.delete('sourceSnapshot'))
              raise ArgumentError.new('Invalid source snapshot') unless snap
              body_object['sourceSnapshot'] = @api_url + snap.resource_url
            elsif opts.has_key?('sizeGb')
              # New blank disk
              body_object['sizeGb'] = opts.delete('sizeGb')
            else
              raise ArgumentError.new('Must specify image OR snapshot OR '\
                                      'disk size when creating a disk.')
            end

          end

          # Merge in any remaining options (only 'description' should remain)
          body_object.merge!(opts)

          result = self.build_result(api_method, parameters,
                                     body_object)
          response = self.build_response(result)
        end

      end

    end
  end
end
