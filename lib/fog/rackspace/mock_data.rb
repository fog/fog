module Fog
  module Rackspace
    module MockData
      
      NOT_FOUND_ID = "NOT-FOUND"
      
      def data
        @@data ||= Hash.new do |hash, key|
          hash[key] = begin
            #Compute V2
            flavor_id = Fog.credentials[:rackspace_flavor_id].to_s ||= Fog::Mock.random_numbers(1)
            image_id  = Fog.credentials[:rackspace_image_id] ||= Fog::Rackspace::MockData.uuid
            image_name = Fog::Mock.random_letters(6)
            network_id = Fog::Rackspace::MockData.uuid

            flavor = {
              "OS-FLV-DISABLED:disabled" => false,
              "disk"  => 20,
              "id"    => flavor_id,
              "links" => [
                {
                  "href" => "https://dfw.servers.api.rackspacecloud.com/v2/010101/flavors/#{flavor_id}",
                  "rel"  => "self"
                },
                {
                  "href" => "https://dfw.servers.api.rackspacecloud.com/010101/flavors/#{flavor_id}",
                  "rel"  => "bookmark"
                }
              ],
                "name"        => "512MB Standard Instance",
                "ram"         => 512,
                "rxtx_factor" => 2.0,
                "swap"        => 512,
                "vcpus"       => 1,
            }

            image = {
              "OS-DCF:diskConfig" => "AUTO",
              "created" => "2012-02-28T19:38:57Z",
              "id" => image_id,
              "name" => "Ubuntu",
              "links" => [
                {
                  "href" => "https://dfw.servers.api.rackspacecloud.com/v2/010101/images/#{image_id}",
                  "rel"  => "self"
                },
                {
                  "href" => "https://dfw.servers.api.rackspacecloud.com/010101/images/#{image_id}",
                  "rel"  => "bookmark"
                },
                {
                  "href" => "https://dfw.servers.api.rackspacecloud.com/010101/images/#{image_id}",
                  "rel"  => "alternate",
                  "type" => "application/vnd.openstack.image"
                }
              ],
                "metadata" => {
                "arch" => "x86-64",
                "auto_disk_config" => "True",
                "com.rackspace__1__build_core" => "1",
                "com.rackspace__1__build_managed" => "0",
                "com.rackspace__1__build_rackconnect" => "0",
                "com.rackspace__1__options" => "0",
                "com.rackspace__1__visible_core" => "1",
                "com.rackspace__1__visible_managed" => "0",
                "com.rackspace__1__visible_rackconnect" => "0",
                "image_type" => "base",
                "org.openstack__1__architecture" => "x64",
                "org.openstack__1__os_distro" => "org.ubuntu",
                "org.openstack__1__os_version" => "11.10",
                "os_distro" => "ubuntu",
                "os_type" => "linux",
                "os_version" => "11.10",
                "rax_managed" => "false",
                "rax_options" => "0"
              },
              "minDisk"  => 10,
              "minRam"   => 256,
              "name"     => image_name,
              "progress" => 100,
              "status"   => "ACTIVE",
              "updated"  => "2012-02-28T19:39:05Z"
            }

            network = {
              'id' => network_id,
              'label' => 'network label',
              'cidr' => '192.168.0.0/24'
            }

            #Block Storage
            volume_type1_id = Fog::Mock.random_numbers(3).to_i
            volume_type2_id = Fog::Mock.random_numbers(3).to_i

            volume_type1 = {
              "id" => volume_type1_id,
              "name" => "SATA",
              "extra_specs" => {},
            }

            volume_type2 = {
              "id" => volume_type2_id,
              "name" => "SSD",
              "extra_specs" => {},
            }

            mock_data = {
              #Compute V2
              :flavors => Hash.new { |h,k| h[k] = flavor unless k == NOT_FOUND_ID},
              :images => Hash.new { |h,k| h[k] = image unless k == NOT_FOUND_ID },        
              :networks => Hash.new { |h,k| h[k] = network unless k == NOT_FOUND_ID },

              :servers => {},

              #Block Storage
              :volumes            => {},
              :snapshots          => {},
              :volume_attachments => [],
              :volume_types       => {volume_type1_id => volume_type1, volume_type2_id => volume_type2},
            }
            
            # seed with initial data
            mock_data[:flavors][flavor_id] = flavor
            mock_data[:images][image_id] = image
            mock_data[:networks][network_id] = network
            
            mock_data
          end
        end[@rackspace_api_key]
      end

      def self.uuid
        [8,4,4,4,12].map{|i| Fog::Mock.random_hex(i)}.join("-")
      end

      def self.ipv4_address
        4.times.map{ Fog::Mock.random_numbers(3) }.join(".")
      end

      def self.ipv6_address
        8.times.map { Fog::Mock.random_hex(4) }.join(":")
      end

      def self.keep(hash, *keys)
        {}.tap do |kept|
          keys.each{|k| kept[k]= hash[k] if hash.key?(k)}
        end
      end

      def self.slice(hash, *keys)
        hash.dup.tap do |sliced|
          keys.each{|k| sliced.delete(k)}
        end
      end

      def self.zulu_time
        Time.now.strftime("%Y-%m-%dT%H:%M:%SZ")
      end
    end
  end
end
