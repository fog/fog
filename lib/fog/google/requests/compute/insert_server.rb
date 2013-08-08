module Fog
  module Compute
    class Google

      class Mock

        def insert_server(server_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def format_metadata(metadata)
          { "items" => metadata.map {|k,v| {"key" => k, "value" => v}} }
        end

        def insert_server(server_name, zone_name, options={}, *deprecated_args)
          if deprecated_args.length > 0 or not options.is_a? Hash
            raise ArgumentError.new 'Too many parameters specified. This may be the cause of code written for an outdated'\
                ' version of fog. Usage: server_name, zone_name, [options]'
          end
          api_method = @compute.instances.insert
          parameters = {
              'project' => @project,
              'zone' => zone_name,
          }
          body_object = {:name => server_name}

          if options.has_key? 'image'
            image_name = options.delete 'image'
            image = images.get(image_name)
            @image_url = @api_url + image.resource_url
            body_object['image'] = @image_url
          end
          body_object['machineType'] = @api_url + @project + "/zones/#{zone_name}/machineTypes/#{options.delete 'machineType'}"
          network = nil
          if options.has_key? 'network'
            network = options.delete 'network'
          elsif @default_network
            network = @default_network
          end

          # ExternalIP is default value for server creation
          if options.has_key? 'externalIp'
            external_ip = options.delete 'externalIp'
          else
             external_ip = true
          end

          networkInterfaces = []
          if ! network.nil?
            networkInterface = { 'network' => @api_url + @project + "/global/networks/#{network}" }
            if external_ip
              networkInterface['accessConfigs'] = [{'type' => 'ONE_TO_ONE_NAT', 'name' => 'External NAT'}]
            end
            networkInterfaces <<  networkInterface
          end

          # TODO: add other networks
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

          options['metadata'] = format_metadata options['metadata'] if options['metadata']

          if options['kernel']
            body_object['kernel'] = @api_url + "google/global/kernels/#{options.delete 'kernel'}"
          end
          body_object.merge! options # Adds in all remaining options that weren't explicitly handled.

          result = self.build_result(api_method, parameters,
                                     body_object=body_object)
          response = self.build_response(result)
        end
      end
    end
  end
end
