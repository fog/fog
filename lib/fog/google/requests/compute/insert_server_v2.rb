module Fog
  module Compute
    class Google

      class Mock

        def insert_server_v2(server_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def insert_server_v2(zone_name, options={})
          api_method = @compute.instances.insert
          parameters = {
              'project' => @project,
              'zone' => zone_name,
          }
          body_object = {}

          if options.has_key? 'image'
            image_name = options.delete 'image'
            # We need to check if the image is owned by the user or a global image.
            if get_image(image_name, @project).data[:status] == 200
              image_url = @api_url + @project + "/global/images/#{image_name}"
            else
              image_url = @api_url + "google/global/images/#{image_name}"
            end
            body_object['image'] = image_url
          end
          body_object['machineType'] = @api_url + @project + "/global/machineTypes/#{options.delete 'machineType'}"
          networkInterfaces = []
          if @default_network
            networkInterfaces << {
                'network' => @api_url + @project + "/global/networks/#{@default_network}",
                'accessConfigs' => [
                    {'type' => 'ONE_TO_ONE_NAT'}
                ]
            }
          end
          #TODO add other networks
          body_object['networkInterfaces'] = networkInterfaces

          if options['disks']
            disks = []
            options.delete('disks').each do |disk|
              if disk.is_a? Disk
                disks << disk.get_object
              else
                disks << disk
              end
            end
            body_object['disks'] = disks
          end

          if options['kernel']
            body_object['kernel'] = @api_url + "google/global/kernels/#{options.delete 'kernel'}"
          end
          body_object.merge! options #adds in all remaining options that weren't explicitly handled

          result = self.build_result(api_method, parameters,
                                     body_object=body_object)
          response = self.build_response(result)
        end

      end
    end
  end
end
