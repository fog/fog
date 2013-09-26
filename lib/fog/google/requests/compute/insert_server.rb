module Fog
  module Compute
    class Google

      class Mock
        def insert_server(server_name, zone_name, options={}, *deprecated_args)

          # check that image and zone exist
          image_project = nil
          if options.has_key? 'image'
            ([ @project ] + Fog::Compute::Google::Images::GLOBAL_PROJECTS).each do |project|
              image_project = project
              break if self.class.data[project][:images][options['image']]
            end
            get_image(options['image'], image_project) # ok if image exists, will fail otherwise
          end
          get_zone(zone_name)

          self.data[:servers][server_name] = {
            "kind" => "compute#instance",
            "id" => Fog::Mock.random_numbers(19),
            "creationTimestamp" => Time.now.iso8601,
            "zone" => "https://www.googleapis.com/compute/v1beta15/projects/#{@project}/zones/#{zone_name}",
            "status" => "PROVISIONING",
            "name" => server_name,
            "tags" => { "fingerprint" => "42WmSpB8rSM=" },
            "machineType" => "https://www.googleapis.com/compute/v1beta15/projects/#{@project}/zones/#{zone_name}/machineTypes/#{options['machineType']}",
            "image" => "https://www.googleapis.com/compute/v1beta15/projects/centos-cloud/global/images/#{options['image']}",
            "kernel" => "https://www.googleapis.com/compute/v1beta15/projects/google/global/kernels/gce-v20130813",
            "canIpForward" => false,
            "networkInterfaces" => [
              {
                "network" => "https://www.googleapis.com/compute/v1beta15/projects/#{@project}/global/networks/default",
                "networkIP" => Fog::Mock.random_ip,
                "name" => "nic0",
                "accessConfigs" => [
                  {
                    "kind" => "compute#accessConfig",
                    "type" => "ONE_TO_ONE_NAT",
                    "name" => "External NAT",
                    "natIP" => Fog::Mock.random_ip
                  }
                ]
              }
            ],
            "disks" => [
              {
                "kind" => "compute#attachedDisk",
                "index" => 0,
                "type" => "SCRATCH",
                "mode" => "READ_WRITE"
              }
            ],
            "metadata" => {
              "kind" => "compute#metadata",
              "fingerprint" => "5_hasd_gC3E=",
              "items" => [
                {
                  "key" => "sshKeys",
                  "value" => "sysadmin:ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEA1zc7mx+0H8Roywet/L0aVX6MUdkDfzd/17kZhprAbpUXYOILv9AG4lIzQk6xGxDIltghytjfVGme/4A42Sb0Z9LN0pxB4KnWTNoOSHPJtp6jbXpq6PdN9r3Z5NKQg0A/Tfw7gt2N0GDsj6vpK8VbHHdW78JAVUxql18ootJxjaksdocsiHNK8iA6/v9qiLRhX3fOgtK7KpxxdZxLRzFg9vkp8jcGISgpZt27kOgXWhR5YLhi8pRJookzphO5O4yhflgoHoAE65XkfrsRCe0HU5QTbY2jH88rBVkq0KVlZh/lEsuwfmG4d77kEqaCGGro+j1Wrvo2K3DSQ+rEcvPp2CYRUySjhaeLF18UzQLtxNeoN14QOYqlm9ITdkCnmq5w4Wn007MjSOFp8LEq2RekrnddGXjg1/vgmXtaVSGzJAlXwtVfZor3dTRmF0JCpr7DsiupBaDFtLUlGFFlSKmPDVMPOOB5wajexmcvSp2Vu4U3yP8Lai/9/ZxMdsGPhpdCsWVL83B5tF4oYj1HVIycbYIxIIfFqOxZcCru3CMfe9jmzKgKLv2UtkfOS8jpS/Os2gAiB3wPweH3agvtwYAYBVMDwt5cnrhgHYWoOz7ABD8KgmCrD7Y9HikiCqIUNkgUFd9YmjcYi5FkU5rFXIawN7efs341lsdf923lsdf923fs= johndoe@acme"
                }
              ]
            },
            "selfLink" => "https://www.googleapis.com/compute/v1beta15/projects/#{@project}/zones/#{zone_name}/instances/#{server_name}"
          }

          build_response(:body => {
            "kind" => "compute#operation",
            "id" => "4639689000254420481",
            "name" => "operation-1380213292196-4e74bf2fbc3c1-ae707d47",
            "zone" => "https://www.googleapis.com/compute/v1beta15/projects/#{@project}/zones/#{zone_name}",
            "operationType" => "insert",
            "targetLink" => "https://www.googleapis.com/compute/v1beta15/projects/#{@project}/zones/#{zone_name}/instances/#{server_name}",
            "status" => "PENDING",
            "user" => "123456789012-qwertyuiopasdfghjkl1234567890qwe@developer.gserviceaccount.com",
            "progress" => 0,
            "insertTime" => Time.now.iso8601,
            "startTime" => Time.now.iso8601,
            "selfLink" => "https://www.googleapis.com/compute/v1beta15/projects/#{@project}/zones/#{zone_name}/operations/operation-1380213292196-4e74bf2fbc3c1-ae707d47"
          })
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
