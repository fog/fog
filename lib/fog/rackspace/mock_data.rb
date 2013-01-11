module Fog
  module Rackspace
    module MockData
      def data
        @@data ||= Hash.new do |hash, key|
          hash[key] = begin

                        #Compute V2
                        flavor_id = Fog.credentials[:rackspace_flavor_id].to_s ||= Fog::Mock.random_numbers(1)
                        image_id  = Fog.credentials[:rackspace_image_id] ||= Fog::Rackspace.uuid
                        image_name = Fog::Mock.random_letters(6)

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

                        #Mock Data Hash
                        {
                          #Compute V2
                          :flavors => {flavor_id => flavor},
                          :images  => {image_id => image},
                          :servers => {},

                          #Block Storage
                          :volumes            => {},
                          :snapshots          => {},
                          :volume_attachments => [],
                          :volume_types       => {volume_type1_id => volume_type1, volume_type2_id => volume_type2},
                        }
                      end
        end[@rackspace_api_key]
      end
    end
  end
end
