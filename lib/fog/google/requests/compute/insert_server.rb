module Fog
  module Compute
    class Google

      class Mock
        include Shared

        def handle_disks(options, zone_name)
          disks = []
          i = 0
          options.delete('disks').each do |disk|
            disk = Disk.new(disk) unless disk.is_a? Disk
            disks << {
              "kind"=>"compute#attachedDisk",
              "index"=>i,
              "type"=>"PERSISTENT",
              "mode"=>"READ_WRITE",
              "source"=>"https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/disks/#{disk.name}",
              "deviceName"=>"persistent-disk-#{i}",
              "boot"=>true
            }
            i+=1
          end
          disks
        end

        def insert_server(server_name, zone_name, options={}, *deprecated_args)

          # check that image and zone exist
          image_project = nil
          if options.has_key? 'image'
            ([ @project ] + Fog::Compute::Google::Images::GLOBAL_PROJECTS).each do |project|
              image_project = project
              break if data(project)[:images][options['image']]
            end
            get_image(options['image'], image_project) # ok if image exists, will fail otherwise
          end
          get_zone(zone_name)

          id = Fog::Mock.random_numbers(19).to_s
          self.data[:servers][server_name] = {
            "kind" => "compute#instance",
            "id" => id,
            "creationTimestamp" => Time.now.iso8601,
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}",
            "status" => "PROVISIONING",
            "name" => server_name,
            "tags" => { "fingerprint" => "42WmSpB8rSM=" },
            "machineType" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/machineTypes/#{options['machineType']}",
            "image" => "https://www.googleapis.com/compute/#{api_version}/projects/#{image_project}/global/images/#{options['image']}",
            "kernel" => "https://www.googleapis.com/compute/#{api_version}/projects/google/global/kernels/gce-v20130813",
            "canIpForward" => false,
            "networkInterfaces" => [
              {
                "network" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/networks/default",
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
            "disks" => options['disks'] ? handle_disks(options, zone_name) : [
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
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/instances/#{server_name}"
          }

          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}",
            "operationType" => "insert",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/instances/#{server_name}",
            "targetId" => id,
            "status" => Fog::Compute::Google::Operation::PENDING_STATE,
            "user" => "123456789012-qwertyuiopasdfghjkl1234567890qwe@developer.gserviceaccount.com",
            "progress" => 0,
            "insertTime" => Time.now.iso8601,
            "startTime" => Time.now.iso8601,
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/operations/#{operation}"
          }

          build_response(:body => self.data[:operations][operation])
        end

      end

      class Real
        include Shared

        def handle_disks(options)
          disks = []
          options.delete('disks').each do |disk|
            if disk.is_a? Disk
              disks << disk.get_object
            else
              disks << disk
            end
          end
          disks
        end

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
          access_config = {'type' => 'ONE_TO_ONE_NAT', 'name' => 'External NAT'}
          # leave natIP undefined to use an IP from a shared ephemeral IP address pool
          if options.has_key? 'externalIp'
            access_config['natIP'] = options.delete 'externalIp'
          end

          networkInterfaces = []
          if ! network.nil?
            networkInterface = { 'network' => @api_url + @project + "/global/networks/#{network}" }
            networkInterface['accessConfigs'] = [access_config]
            networkInterfaces <<  networkInterface
          end

          # TODO: add other networks
          body_object['networkInterfaces'] = networkInterfaces

          body_object['disks'] = handle_disks(options) if options['disks']

          options['metadata'] = format_metadata options['metadata'] if options['metadata']

          body_object['tags'] = { 'items' => options.delete('tags') } if options['tags']

          if options['kernel']
            body_object['kernel'] = @api_url + "google/global/kernels/#{options.delete 'kernel'}"
          end
          body_object.merge!(options) # Adds in all remaining options that weren't explicitly handled.

          result = self.build_result(api_method, parameters,
                                     body_object=body_object)
          response = self.build_response(result)
        end
      end
    end
  end
end
