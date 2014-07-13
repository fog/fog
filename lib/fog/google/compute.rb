require 'fog/google/core'

module Fog
  module Compute
    class Google < Fog::Service
      requires :google_project
      recognizes :app_name, :app_version, :google_client_email, :google_key_location, :google_key_string, :google_client

      request_path 'fog/google/requests/compute'
      request :list_servers
      request :list_aggregated_servers
      request :list_addresses
      request :list_aggregated_addresses
      request :list_disks
      request :list_aggregated_disks
      request :list_disk_types
      request :list_aggregated_disk_types
      request :list_firewalls
      request :list_images
      request :list_machine_types
      request :list_aggregated_machine_types
      request :list_networks
      request :list_zones
      request :list_regions
      request :list_global_operations
      request :list_region_operations
      request :list_zone_operations
      request :list_snapshots
      request :list_http_health_checks
      request :list_target_pools
      request :list_forwarding_rules
      request :list_routes

      request :get_server
      request :get_address
      request :get_disk
      request :get_disk_type
      request :get_firewall
      request :get_image
      request :get_machine_type
      request :get_network
      request :get_zone
      request :get_region
      request :get_snapshot
      request :get_global_operation
      request :get_region_operation
      request :get_zone_operation
      request :get_http_health_check
      request :get_target_pool
      request :get_target_pool_health
      request :get_forwarding_rule
      request :get_project
      request :get_route

      request :delete_address
      request :delete_disk
      request :delete_snapshot
      request :delete_firewall
      request :delete_image
      request :delete_network
      request :delete_server
      request :delete_global_operation
      request :delete_region_operation
      request :delete_zone_operation
      request :delete_http_health_check
      request :delete_target_pool
      request :delete_forwarding_rule
      request :delete_route

      request :insert_address
      request :insert_disk
      request :insert_firewall
      request :insert_image
      request :insert_network
      request :insert_server
      request :insert_snapshot
      request :insert_http_health_check
      request :insert_target_pool
      request :insert_forwarding_rule
      request :insert_route

      request :set_metadata
      request :set_tags
      request :set_forwarding_rule_target

      request :add_target_pool_instances
      request :add_target_pool_health_checks

      request :remove_target_pool_instances
      request :remove_target_pool_health_checks
      request :set_common_instance_metadata

      request :attach_disk
      request :detach_disk
      request :get_server_serial_port_output
      request :reset_server
      request :set_server_disk_auto_delete
      request :set_server_scheduling
      request :add_server_access_config
      request :delete_server_access_config

      model_path 'fog/google/models/compute'
      model :server
      collection :servers

      model :image
      collection :images

      model :flavor
      collection :flavors

      model :disk
      collection :disks

      model :disk_type
      collection :disk_types

      model :address
      collection :addresses

      model :operation
      collection :operations

      model :snapshot
      collection :snapshots

      model :zone
      collection :zones

      model :region
      collection :regions

      model :http_health_check
      collection :http_health_checks

      model :target_pool
      collection :target_pools

      model :forwarding_rule
      collection :forwarding_rules

      model :project
      collection :projects

      model :firewall
      collection :firewalls

      model :network
      collection :networks

      model :route
      collection :routes

      module Shared
        attr_reader :project, :api_version

        def shared_initialize(options = {})
          @project = options[:google_project]
          @api_version = 'v1'
          base_url = 'https://www.googleapis.com/compute/'
          @api_url = base_url + api_version + '/projects/'
          @default_network = 'default'
        end

        def build_excon_response(body, status=200)
          response = Excon::Response.new
          response.body = body
          if response.body and response.body["error"]
            response.status = response.body["error"]["code"]
            if response.body["error"]["errors"]
              msg = response.body["error"]["errors"].map{|error| error["message"]}.join(", ")
            else
              msg = "Error [#{response.body["error"]["code"]}]: #{response.body["error"]["message"] || "GCE didn't return an error message"}"
            end
            case response.status
            when 404
              raise Fog::Errors::NotFound.new(msg)
            else
              raise Fog::Errors::Error.new(msg)
            end
          else
            response.status = status
          end
          response
        end

      end

      class Mock
        include Collections
        include Shared

        def initialize(options={})
          shared_initialize(options)
        end

        def build_response(params={})
          body = params[:body] || {}
          build_excon_response(body)
        end

        def self.data(api_version)
          @data ||= Hash.new do |hash, key|
            case key
            when 'debian-cloud'
              hash[key] = {
                :images => {
                  "debian-6-squeeze-v20130816" => {
                    "kind" => "compute#image",
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/debian-cloud/global/images/debian-6-squeeze-v20130816",
                    "id" => "14841592146580482051",
                    "creationTimestamp" => "2013-09-04T13:21:53.292-07:00",
                    "name" => "debian-6-squeeze-v20130816",
                    "description" => "Debian GNU/Linux 6.0.7 (squeeze) built on 2013-08-16",
                    "sourceType" => "RAW",
                    "rawDisk" => {
                      "containerType" => "TAR",
                      "source" => ""
                    },
                    "status" => "READY"
                  },
                  "debian-7-wheezy-v20130816" => {
                    "kind" => "compute#image",
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/debian-cloud/global/images/debian-7-wheezy-v20130816",
                    "id" => "4213305957435180899",
                    "creationTimestamp" => "2013-09-04T13:24:30.479-07:00",
                    "name" => "debian-7-wheezy-v20130816",
                    "description" => "Debian GNU/Linux 7.1 (wheezy) built on 2013-08-16",
                    "sourceType" => "RAW",
                    "rawDisk" => {
                      "containerType" => "TAR",
                      "source" => ""
                    },
                    "status" => "READY"
                  },
                  "debian-7-wheezy-v20131014" => {
                    "kind" => "compute#image",
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/debian-cloud/global/images/debian-7-wheezy-v20131014",
                    "id" => "4213305957435180899",
                    "creationTimestamp" => "2013-09-04T13:24:30.479-07:00",
                    "name" => "debian-7-wheezy-v20131014",
                    "description" => "Debian GNU/Linux 7.1 (wheezy) built on 2013-10-14",
                    "sourceType" => "RAW",
                    "rawDisk" => {
                      "containerType" => "TAR",
                      "source" => ""
                    },
                    "status" => "READY"
                  },
                  "debian-7-wheezy-v20140408" => {
                    "kind" => "compute#image",
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/debian-cloud/global/images/debian-7-wheezy-v20140408",
                    "id" => "17312518942796567788",
                    "creationTimestamp" => "2013-11-25T15:17:00.436-08:00",
                    "name" => "debian-7-wheezy-v20131120",
                    "description" => "Debian GNU/Linux 7.2 (wheezy) built on 2013-11-20",
                    "sourceType" => "RAW",
                    "rawDisk" => {
                      "containerType" => "TAR",
                      "source" => ""
                    },
                    "status" => "READY",
                    "archiveSizeBytes" => "341857472"
                  }
                }
              }
            when 'centos-cloud'
              hash[key] = {
                :images => {
                  "centos-6-v20130813" => {
                    "kind" => "compute#image",
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/centos-cloud/global/images/centos-6-v20130813",
                    "id" => "4670523370938782739",
                    "creationTimestamp" => "2013-08-19T11:56:47.004-07:00",
                    "name" => "centos-6-v20130813",
                    "description" => "SCSI-enabled CentOS 6; Created Tue, 13 Aug 2013 00:00:00 +0000",
                    "sourceType" => "RAW",
                    "rawDisk" => {
                      "containerType" => "TAR",
                      "source" => ""
                    },
                    "status" => "READY"
                  }
                }
              }
            else
              hash[key] = {
                :servers => {
                  "fog-1" => {
                    "kind" => "compute#instance",
                    "id" => "1361932147851415727",
                    "creationTimestamp" => "2013-09-26T04:55:43.881-07:00",
                    "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/us-central1-a",
                    "status" => "RUNNING",
                    "name" => "fog-1380196541",
                    "tags" => { "fingerprint" => "42WmSpB8rSM=" },
                    "machineType" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/us-central1-a/machineTypes/n1-standard-1",
                    "canIpForward" => false,
                    "networkInterfaces" => [
                      {
                        "network" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/global/networks/default",
                        "networkIP" => "10.240.121.54",
                        "name" => "nic0",
                        "accessConfigs" => [
                          {
                            "kind" => "compute#accessConfig",
                            "type" => "ONE_TO_ONE_NAT",
                            "name" => "External NAT",
                            "natIP" => "108.59.81.28"
                          }
                        ]
                      }
                    ],
                    "disks" => [
                      {
                        "kind" => "compute#attachedDisk",
                        "index" => 0,
                        "type" => "PERSISTENT",
                        "mode" => "READ_WRITE",
                        "source" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/us-central1-a/disks/fog-1",
                        "deviceName" => "persistent-disk-0",
                        "boot" => true
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
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/us-central1-a/instances/fog-1380196541"
                  }
                },
                :zones => {
                  "europe-west1-a" => {
                    "kind" => "compute#zone",
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/europe-west1-a",
                    "id" => "10419676573632995924",
                    "creationTimestamp" => "2013-09-26T02:56:13.115-07:00",
                    "name" => "europe-west1-a",
                    "description" => "europe-west1-a",
                    "status" => "UP",
                    "maintenanceWindows" => [
                      {
                        "name" => "2014-01-18-planned-outage",
                        "description" => "maintenance zone",
                        "beginTime" => "2014-01-18T12:00:00.000-08:00",
                        "endTime" => "2014-02-02T12:00:00.000-08:00"
                      }
                    ],
                    "quotas" => [
                      {"metric" => "INSTANCES", "limit" => 16.0, "usage" => 0.0},
                      {"metric" => "CPUS", "limit" => 24.0, "usage" => 0.0},
                      {"metric" => "DISKS", "limit" => 16.0, "usage" => 0.0},
                      {"metric" => "DISKS_TOTAL_GB", "limit" => 2048.0, "usage" => 0.0}
                    ],
                    "region" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/regions/europe-west1"
                  },
                  "us-central1-a" => {
                    "kind" => "compute#zone",
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/us-central1-a",
                    "id" => "6562457277909136262",
                    "creationTimestamp" => "2013-09-26T02:56:13.116-07:00",
                    "name" => "us-central1-a",
                    "description" => "us-central1-a",
                    "status" => "UP",
                    "maintenanceWindows" => nil,
                    "quotas" => [
                      {"metric" => "INSTANCES", "limit" => 16.0, "usage" => 1.0},
                      {"metric" => "CPUS", "limit" => 24.0, "usage" => 1.0},
                      {"metric" => "DISKS", "limit" => 16.0, "usage" => 0.0},
                      {"metric" => "DISKS_TOTAL_GB", "limit" => 2048.0, "usage" => 0.0}
                    ],
                    "region" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/regions/us-central1"
                  },
                  "us-central1-b" => {
                    "kind" => "compute#zone",
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/us-central1-b",
                    "id" => "8701502109626061015",
                    "creationTimestamp" => "2013-09-26T02:56:13.124-07:00",
                    "name" => "us-central1-b",
                    "description" => "us-central1-b",
                    "status" => "UP",
                    "maintenanceWindows" => [{"name" => "2013-10-26-planned-outage",
                      "description" => "maintenance zone",
                    "beginTime" => "2013-10-26T12:00:00.000-07:00",
                    "endTime" => "2013-11-10T12:00:00.000-08:00"}],
                    "quotas" => [
                      {"metric" => "INSTANCES", "limit" => 16.0, "usage" => 0.0},
                      {"metric" => "CPUS", "limit" => 24.0, "usage" => 0.0},
                      {"metric" => "DISKS", "limit" => 16.0, "usage" => 0.0},
                      {"metric" => "DISKS_TOTAL_GB", "limit" => 2048.0, "usage" => 0.0}
                    ],
                    "region" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/regions/us-central1"
                  },
                  "us-central2-a" => {
                    "kind" => "compute#zone",
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/us-central2-a",
                    "id" => "13611654493253680292",
                    "creationTimestamp" => "2013-09-26T02:56:13.125-07:00",
                    "name" => "us-central2-a",
                    "description" => "us-central2-a",
                    "status" => "UP",
                    "maintenanceWindows" => [
                      {
                        "name" => "2013-10-12-planned-outage",
                        "description" => "maintenance zone",
                        "beginTime" => "2013-10-12T12:00:00.000-07:00",
                        "endTime" => "2013-10-27T12:00:00.000-07:00"
                      }
                    ],
                    "quotas" => [
                      {"metric" => "INSTANCES", "limit" => 16.0, "usage" => 0.0},
                      {"metric" => "CPUS", "limit" => 24.0, "usage" => 0.0},
                      {"metric" => "DISKS", "limit" => 16.0, "usage" => 0.0},
                      {"metric" => "DISKS_TOTAL_GB", "limit" => 2048.0, "usage" => 0.0}
                    ],
                    "region" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/regions/us-central2"
                  }
                },
                :machine_types => Hash.new do |machine_types_hash, zone|
                  machine_types_hash[zone] = {
                    "f1-micro" => {
                      "kind" => "compute#machineType",
                      "id" => "4618642685664990776",
                      "creationTimestamp" => "2013-04-25T13:32:49.088-07:00",
                      "name" => "f1-micro",
                      "description" => "1 vCPU (shared physical core) and 0.6 GB RAM",
                      "guestCpus" => 1,
                      "memoryMb" => 614,
                      "imageSpaceGb" => 0,
                      "maximumPersistentDisks" => 4,
                      "maximumPersistentDisksSizeGb" => "3072",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/f1-micro"
                    },
                    "g1-small" => {
                      "kind" => "compute#machineType",
                      "id" => "7224129552184485774",
                      "creationTimestamp" => "2013-04-25T13:32:45.550-07:00",
                      "name" => "g1-small",
                      "description" => "1 vCPU (shared physical core) and 1.7 GB RAM",
                      "guestCpus" => 1,
                      "memoryMb" => 1740,
                      "imageSpaceGb" => 0,
                      "maximumPersistentDisks" => 4,
                      "maximumPersistentDisksSizeGb" => "3072",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/g1-small"
                    },
                    "n1-highcpu-2" => {
                      "kind" => "compute#machineType",
                      "id" => "13043554592196512955",
                      "creationTimestamp" => "2012-11-16T11:46:10.572-08:00",
                      "name" => "n1-highcpu-2",
                      "description" => "2 vCPUs, 1.8 GB RAM",
                      "guestCpus" => 2,
                      "memoryMb" => 1843,
                      "imageSpaceGb" => 10,
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-highcpu-2"
                    },
                    "n1-highcpu-2-d" => {
                      "kind" => "compute#machineType",
                      "id" => "13043555176034896271",
                      "creationTimestamp" => "2012-11-16T11:47:07.825-08:00",
                      "name" => "n1-highcpu-2-d",
                      "description" => "2 vCPUs, 1.8 GB RAM, 1 scratch disk (870 GB)",
                      "guestCpus" => 2,
                      "memoryMb" => 1843,
                      "imageSpaceGb" => 10,
                      "scratchDisks" => [
                       {
                        "diskGb" => 870
                       }
                      ],
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-highcpu-2-d"
                    },
                    "n1-highcpu-4" => {
                      "kind" => "compute#machineType",
                      "id" => "13043555705736970382",
                      "creationTimestamp" => "2012-11-16T11:48:06.087-08:00",
                      "name" => "n1-highcpu-4",
                      "description" => "4 vCPUs, 3.6 GB RAM",
                      "guestCpus" => 4,
                      "memoryMb" => 3686,
                      "imageSpaceGb" => 10,
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-highcpu-4"
                    },
                    "n1-highcpu-4-d" => {
                      "kind" => "compute#machineType",
                      "id" => "13043556330284250611",
                      "creationTimestamp" => "2012-11-16T11:49:07.563-08:00",
                      "name" => "n1-highcpu-4-d",
                      "description" => "4 vCPUS, 3.6 GB RAM, 1 scratch disk (1770 GB)",
                      "guestCpus" => 4,
                      "memoryMb" => 3686,
                      "imageSpaceGb" => 10,
                      "scratchDisks" => [
                       {
                        "diskGb" => 1770
                       }
                      ],
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-highcpu-4-d"
                    },
                    "n1-highcpu-8" => {
                      "kind" => "compute#machineType",
                      "id" => "13043556949665240937",
                      "creationTimestamp" => "2012-11-16T11:50:15.128-08:00",
                      "name" => "n1-highcpu-8",
                      "description" => "8 vCPUs, 7.2 GB RAM",
                      "guestCpus" => 8,
                      "memoryMb" => 7373,
                      "imageSpaceGb" => 10,
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-highcpu-8"
                    },
                    "n1-highcpu-8-d" => {
                      "kind" => "compute#machineType",
                      "id" => "13043557458004959701",
                      "creationTimestamp" => "2012-11-16T11:51:04.549-08:00",
                      "name" => "n1-highcpu-8-d",
                      "description" => "8 vCPUS, 7.2 GB RAM, 2 scratch disks (1770 GB, 1770 GB)",
                      "guestCpus" => 8,
                      "memoryMb" => 7373,
                      "imageSpaceGb" => 10,
                      "scratchDisks" => [
                       {
                        "diskGb" => 1770
                       },
                       {
                        "diskGb" => 1770
                       }
                      ],
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-highcpu-8-d"
                    },
                    "n1-highmem-2" => {
                      "kind" => "compute#machineType",
                      "id" => "13043551079318055993",
                      "creationTimestamp" => "2012-11-16T11:40:06.129-08:00",
                      "name" => "n1-highmem-2",
                      "description" => "2 vCPUs, 13 GB RAM",
                      "guestCpus" => 2,
                      "memoryMb" => 13312,
                      "imageSpaceGb" => 10,
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-highmem-2"
                    },
                    "n1-highmem-2-d" => {
                      "kind" => "compute#machineType",
                      "id" => "13043551625558644085",
                      "creationTimestamp" => "2012-11-16T11:40:59.630-08:00",
                      "name" => "n1-highmem-2-d",
                      "description" => "2 vCPUs, 13 GB RAM, 1 scratch disk (870 GB)",
                      "guestCpus" => 2,
                      "memoryMb" => 13312,
                      "imageSpaceGb" => 10,
                      "scratchDisks" => [
                       {
                        "diskGb" => 870
                       }
                      ],
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-highmem-2-d"
                    },
                    "n1-highmem-4" => {
                      "kind" => "compute#machineType",
                      "id" => "13043552263604939569",
                      "creationTimestamp" => "2012-11-16T11:42:08.983-08:00",
                      "name" => "n1-highmem-4",
                      "description" => "4 vCPUs, 26 GB RAM",
                      "guestCpus" => 4,
                      "memoryMb" => 26624,
                      "imageSpaceGb" => 10,
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-highmem-4"
                    },
                    "n1-highmem-4-d" => {
                      "kind" => "compute#machineType",
                      "id" => "13043552953632709737",
                      "creationTimestamp" => "2012-11-16T11:43:17.400-08:00",
                      "name" => "n1-highmem-4-d",
                      "description" => "4 vCPUs, 26 GB RAM, 1 scratch disk (1770 GB)",
                      "guestCpus" => 4,
                      "memoryMb" => 26624,
                      "imageSpaceGb" => 10,
                      "scratchDisks" => [
                       {
                        "diskGb" => 1770
                       }
                      ],
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-highmem-4-d"
                    },
                    "n1-highmem-8" => {
                      "kind" => "compute#machineType",
                      "id" => "13043553584275586275",
                      "creationTimestamp" => "2012-11-16T11:44:25.985-08:00",
                      "name" => "n1-highmem-8",
                      "description" => "8 vCPUs, 52 GB RAM",
                      "guestCpus" => 8,
                      "memoryMb" => 53248,
                      "imageSpaceGb" => 10,
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-highmem-8"
                    },
                    "n1-highmem-8-d" => {
                      "kind" => "compute#machineType",
                      "id" => "13043554021673472746",
                      "creationTimestamp" => "2012-11-16T11:45:08.195-08:00",
                      "name" => "n1-highmem-8-d",
                      "description" => "8 vCPUs, 52 GB RAM, 2 scratch disks (1770 GB, 1770 GB)",
                      "guestCpus" => 8,
                      "memoryMb" => 53248,
                      "imageSpaceGb" => 10,
                      "scratchDisks" => [
                       {
                        "diskGb" => 1770
                       },
                       {
                        "diskGb" => 1770
                       }
                      ],
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-highmem-8-d"
                    },
                    "n1-standard-1" => {
                      "kind" => "compute#machineType",
                      "id" => "12907738072351752276",
                      "creationTimestamp" => "2012-06-07T13:48:14.670-07:00",
                      "name" => "n1-standard-1",
                      "description" => "1 vCPU, 3.75 GB RAM",
                      "guestCpus" => 1,
                      "memoryMb" => 3840,
                      "imageSpaceGb" => 10,
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-standard-1"
                    },
                    "n1-standard-1-d" => {
                      "kind" => "compute#machineType",
                      "id" => "12908559201265214706",
                      "creationTimestamp" => "2012-06-07T13:48:34.258-07:00",
                      "name" => "n1-standard-1-d",
                      "description" => "1 vCPU, 3.75 GB RAM, 1 scratch disk (420 GB)",
                      "guestCpus" => 1,
                      "memoryMb" => 3840,
                      "imageSpaceGb" => 10,
                      "scratchDisks" => [
                       {
                        "diskGb" => 420
                       }
                      ],
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-standard-1-d"
                    },
                    "n1-standard-2" => {
                      "kind" => "compute#machineType",
                      "id" => "12908559320241551184",
                      "creationTimestamp" => "2012-06-07T13:48:56.867-07:00",
                      "name" => "n1-standard-2",
                      "description" => "2 vCPUs, 7.5 GB RAM",
                      "guestCpus" => 2,
                      "memoryMb" => 7680,
                      "imageSpaceGb" => 10,
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-standard-2"
                    },
                    "n1-standard-2-d" => {
                      "kind" => "compute#machineType",
                      "id" => "12908559582417967837",
                      "creationTimestamp" => "2012-06-07T13:49:19.448-07:00",
                      "name" => "n1-standard-2-d",
                      "description" => "2 vCPUs, 7.5 GB RAM, 1 scratch disk (870 GB)",
                      "guestCpus" => 2,
                      "memoryMb" => 7680,
                      "imageSpaceGb" => 10,
                      "scratchDisks" => [
                       {
                        "diskGb" => 870
                       }
                      ],
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-standard-2-d"
                    },
                    "n1-standard-4" => {
                      "kind" => "compute#machineType",
                      "id" => "12908559692070444049",
                      "creationTimestamp" => "2012-06-07T13:49:40.050-07:00",
                      "name" => "n1-standard-4",
                      "description" => "4 vCPUs, 15 GB RAM",
                      "guestCpus" => 4,
                      "memoryMb" => 15360,
                      "imageSpaceGb" => 10,
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-standard-4"
                    },
                    "n1-standard-4-d" => {
                      "kind" => "compute#machineType",
                      "id" => "12908559991903153608",
                      "creationTimestamp" => "2012-06-07T13:50:05.677-07:00",
                      "name" => "n1-standard-4-d",
                      "description" => "4 vCPUs, 15 GB RAM, 1 scratch disk (1770 GB)",
                      "guestCpus" => 4,
                      "memoryMb" => 15360,
                      "imageSpaceGb" => 10,
                      "scratchDisks" => [
                       {
                        "diskGb" => 1770
                       }
                      ],
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-standard-4-d"
                    },
                    "n1-standard-8" => {
                      "kind" => "compute#machineType",
                      "id" => "12908560197989714867",
                      "creationTimestamp" => "2012-06-07T13:50:42.334-07:00",
                      "name" => "n1-standard-8",
                      "description" => "8 vCPUs, 30 GB RAM",
                      "guestCpus" => 8,
                      "memoryMb" => 30720,
                      "imageSpaceGb" => 10,
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-standard-8"
                    },
                    "n1-standard-8-d" => {
                      "kind" => "compute#machineType",
                      "id" => "12908560709887590691",
                      "creationTimestamp" => "2012-06-07T13:51:19.936-07:00",
                      "name" => "n1-standard-8-d",
                      "description" => "8 vCPUs, 30 GB RAM, 2 scratch disks (1770 GB, 1770 GB)",
                      "guestCpus" => 8,
                      "memoryMb" => 30720,
                      "imageSpaceGb" => 10,
                      "scratchDisks" => [
                       {
                        "diskGb" => 1770
                       },
                       {
                        "diskGb" => 1770
                       }
                      ],
                      "maximumPersistentDisks" => 16,
                      "maximumPersistentDisksSizeGb" => "10240",
                      "zone" => zone,
                      "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/#{zone}/machineTypes/n1-standard-8-d"
                     }
                  }
                end,
                :images => {},
                :disks => {
                  "fog-1" => {
                    "kind" => "compute#disk",
                    "id" => "3338131294770784461",
                    "creationTimestamp" => "2013-12-18T19:47:10.583-08:00",
                    "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/us-central1-a",
                    "status" => "READY",
                    "name" => "fog-1",
                    "sizeGb" => "10",
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/us-central1-a/disks/fog-1",
                    "sourceImage" => "https://www.googleapis.com/compute/#{api_version}/projects/debian-cloud/global/images/debian-7-wheezy-v20131120",
                    "sourceImageId" => "17312518942796567788",
                    "type" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/us-central1-a/diskTypes/pd-standard",
                  },
                  "fog-2" => {
                    "kind" => "compute#disk",
                    "id" => "3338131294770784462",
                    "creationTimestamp" => "2013-12-18T19:47:10.583-08:00",
                    "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/us-central1-a",
                    "status" => "READY",
                    "name" => "fog-2",
                    "sizeGb" => "10",
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/us-central1-a/disks/fog-1",
                    "type" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/us-central1-a/diskTypes/pd-ssd",
                  }
                },
                :operations => {}
              }
            end
          end
        end

        def self.reset
          @data = nil
        end

        def data(project=@project)
          self.class.data(api_version)[project]
        end

        def reset_data
          # not particularly useful because it deletes zones
          self.class.data(api_version).delete(@project)
        end

        def random_operation
          "operation-#{Fog::Mock.random_numbers(13)}-#{Fog::Mock.random_hex(13)}-#{Fog::Mock.random_hex(8)}"
        end
      end

      class Real
        include Collections
        include Shared

        attr_accessor :client
        attr_reader :compute, :api_url

        def initialize(options)
          # NOTE: loaded here to avoid requiring this as a core Fog dependency
          begin
            require 'google/api_client'
          rescue LoadError => error
            Fog::Logger.warning("Please install the google-api-client gem before using this provider.")
            raise error
          end
          shared_initialize(options)

          if !options[:google_client].nil?
            @client = options[:google_client]
          end

          if @client.nil?
            if !options[:google_key_location].nil?
              google_key = File.expand_path(options[:google_key_location])
            elsif !options[:google_key_string].nil?
              google_key = options[:google_key_string]
            end

            if !options[:google_client_email].nil? and !google_key.nil?
              @client = self.new_pk12_google_client(
                options[:google_client_email],
                google_key,
                options[:app_name],
                options[:app_verion])
            else
              Fog::Logger.debug("Fog::Compute::Google.client has not been initialized nor are the :google_client_email and :google_key_location or :google_key_string options set, so we can not create one for you.")
              raise ArgumentError.new("No Google API Client has been initialized.")
            end
          end

          # We want to always mention we're using Fog.
          if @client.user_agent.nil? or @client.user_agent.empty?
            @client.user_agent = ""
          elsif !@client.user_agent.include? "fog"
            @client.user_agent += "fog/#{Fog::VERSION}"
          end

          @compute = @client.discovered_api('compute', api_version)
        end

        # Public: Create a Google::APIClient with a pkcs12 key and a user email.
        #
        # google_client_email - an @developer.gserviceaccount.com email address to use.
        # google_key - an absolute location to a pkcs12 key file or the content of the file itself.
        # app_name - an optional string to set as the app name in the user agent.
        # app_version - an optional string to set as the app version in the user agent.
        #
        # Returns a new Google::APIClient
        def new_pk12_google_client(google_client_email, google_key, app_name=nil, app_version=nil)
          # The devstorage scope is needed to be able to insert images
          # devstorage.read_only scope is not sufficient like you'd hope
          api_scope_url = 'https://www.googleapis.com/auth/compute https://www.googleapis.com/auth/devstorage.read_write'

          user_agent = ""
          if app_name
            user_agent = "#{app_name}/#{app_version || '0.0.0'} "
          end
          user_agent += "fog/#{Fog::VERSION}"

          api_client_options = {
            # https://github.com/google/google-api-ruby-client/blob/master/lib/google/api_client.rb#L98
            :application_name => "suppress warning",
            # https://github.com/google/google-api-ruby-client/blob/master/lib/google/api_client.rb#L100
            :user_agent => user_agent
          }
          local_client = ::Google::APIClient.new(api_client_options)

          key = ::Google::APIClient::KeyUtils.load_from_pkcs12(google_key, 'notasecret')

          local_client.authorization = Signet::OAuth2::Client.new({
            :audience => 'https://accounts.google.com/o/oauth2/token',
            :auth_provider_x509_cert_url => "https://www.googleapis.com/oauth2/v1/certs",
            :client_x509_cert_url => "https://www.googleapis.com/robot/v1/metadata/x509/#{google_client_email}",
            :issuer => google_client_email,
            :scope => api_scope_url,
            :signing_key => key,
            :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
          })

          local_client.authorization.fetch_access_token!

          return local_client
        end

        def build_result(api_method, parameters, body_object=nil)
          if body_object
            result = @client.execute(
              :api_method => api_method,
              :parameters => parameters,
              :body_object => body_object
            )
          else
            result = @client.execute(
              :api_method => api_method,
              :parameters => parameters
            )
          end
        end

        # result = Google::APIClient::Result
        # returns Excon::Response
        def build_response(result)
          build_excon_response(result.body.nil? || result.body.empty? ? nil : Fog::JSON.decode(result.body), result.status)
        end
      end

      RUNNING = 'RUNNING'
    end
  end
end
