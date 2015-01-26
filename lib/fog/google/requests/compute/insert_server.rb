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
          # check that zone exists
          get_zone(zone_name)

          if options['disks'].nil? or options['disks'].empty?
            raise ArgumentError.new "Empty value for field 'disks'. Boot disk must be specified"
          end
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
            "disks" => handle_disks(options, zone_name),
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

          build_excon_response(self.data[:operations][operation])
        end
      end

      class Real
        include Shared

        def handle_disks(options)
          disks = []
          # An array of persistent disks. You must supply a boot disk as the first disk in
          # this array and mark it as a boot disk using the disks[].boot property.
          options.delete('disks').each do |disk|
            if disk.is_a? Disk
              disks << disk.get_object
            else
              disks << disk
            end
          end
          disks.first['boot'] = true
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

          body_object['machineType'] = @api_url + @project + "/zones/#{zone_name}/machineTypes/#{options.delete 'machineType'}"
          network = nil
          if options.key? 'network'
            network = options.delete 'network'
          else
            network = GOOGLE_COMPUTE_DEFAULT_NETWORK
          end

          # ExternalIP is default value for server creation
          access_config = {'type' => 'ONE_TO_ONE_NAT', 'name' => 'External NAT'}
          # leave natIP undefined to use an IP from a shared ephemeral IP address pool
          if options.key? 'externalIp'
            access_config['natIP'] = options.delete 'externalIp'
            # If set to 'false', that would mean user does no want to allocate an external IP
            access_config = nil if access_config['natIP'] == false
          end

          networkInterfaces = []
          if ! network.nil?
            networkInterface = { 'network' => @api_url + @project + "/global/networks/#{network}" }
            networkInterface['accessConfigs'] = [access_config] if access_config
            networkInterfaces <<  networkInterface
          end

          scheduling = {
            'automaticRestart' => false,
            'onHostMaintenance' => "MIGRATE"
          }
          if options.key? 'auto_restart'
            scheduling['automaticRestart'] = options.delete 'auto_restart'
            scheduling['automaticRestart'] = scheduling['automaticRestart'].class == TrueClass
          end
          if options.key? 'on_host_maintenance'
            ohm = options.delete 'on_host_maintenance'
            scheduling['onHostMaintenance'] = (ohm.respond_to?("upcase") &&
                    ohm.upcase == "MIGRATE" && "MIGRATE") || "TERMINATE"
          end
          body_object['scheduling'] = scheduling

          # @see https://developers.google.com/compute/docs/networking#canipforward
          if options.key? 'can_ip_forward'
            body_object['canIpForward'] = options.delete 'can_ip_forward'
          end

          # TODO: add other networks
          body_object['networkInterfaces'] = networkInterfaces

          if options['disks'].nil? or options['disks'].empty?
            raise ArgumentError.new "Empty value for field 'disks'. Boot disk must be specified"
          end
          body_object['disks'] = handle_disks(options)

          options['metadata'] = format_metadata options['metadata'] if options['metadata']

          body_object['tags'] = { 'items' => options.delete('tags') } if options['tags']

          body_object.merge!(options) # Adds in all remaining options that weren't explicitly handled.

          request(api_method, parameters, body_object=body_object)
        end
      end
    end
  end
end
