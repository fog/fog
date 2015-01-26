require 'fog/google/core'

module Fog
  module Compute
    class Google < Fog::Service
      requires :google_project
      recognizes :app_name, :app_version, :google_client_email, :google_key_location, :google_key_string, :google_client

      GOOGLE_COMPUTE_API_VERSION     = 'v1'
      GOOGLE_COMPUTE_BASE_URL        = 'https://www.googleapis.com/compute/'
      GOOGLE_COMPUTE_API_SCOPE_URLS  = %w(https://www.googleapis.com/auth/compute
                                         https://www.googleapis.com/auth/devstorage.read_write
                                         https://www.googleapis.com/auth/ndev.cloudman
                                         https://www.googleapis.com/auth/cloud-platform)
      GOOGLE_COMPUTE_DEFAULT_NETWORK = 'default'

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
      request :list_backend_services
      request :list_global_forwarding_rules
      request :list_url_maps
      request :list_target_http_proxies
      request :list_zone_views
      request :list_region_views
      request :list_region_view_resources
      request :list_zone_view_resources
      request :list_target_instances

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
      request :get_backend_service
      request :get_backend_service_health
      request :get_url_map
      request :get_global_forwarding_rule
      request :get_target_http_proxy
      request :get_zone_view
      request :get_region_view
      request :get_target_instance

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
      request :delete_backend_service
      request :delete_url_map
      request :delete_target_http_proxy
      request :delete_global_forwarding_rule
      request :delete_zone_view
      request :delete_region_view
      request :delete_target_instance

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
      request :insert_backend_service
      request :insert_url_map
      request :insert_target_http_proxy
      request :insert_global_forwarding_rule
      request :insert_zone_view
      request :insert_region_view
      request :insert_target_instance

      request :set_metadata
      request :set_tags
      request :set_forwarding_rule_target
      request :set_global_forwarding_rule_target
      request :set_target_http_proxy_url_map

      request :add_target_pool_instances
      request :add_target_pool_health_checks
      request :add_backend_service_backends
      request :add_url_map_host_rules
      request :add_url_map_path_matchers
      request :add_zone_view_resources
      request :add_region_view_resources

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
      request :update_url_map
      request :validate_url_map

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

      model :backend_service
      collection :backend_services

      model :target_http_proxy
      collection :target_http_proxies

      model :url_map
      collection :url_maps

      model :global_forwarding_rule
      collection :global_forwarding_rules

      model :resource_view
      collection :resource_views

      model :target_instance
      collection :target_instances

      class Mock
        include Fog::Google::Shared

        def initialize(options)
          shared_initialize(options[:google_project], GOOGLE_COMPUTE_API_VERSION, GOOGLE_COMPUTE_BASE_URL)
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
                :target_http_proxies => {
                  "test-target-http-proxy" => {
                    "kind" => "compute#targetHttpProxy",
                    "id" => "1361932147851415729",
                    "creationTimestamp" => '2014-08-23T10:06:13.951-07:00',
                    "name" => "test-target-http-proxy",
                    "description" => '',
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/targetHttpProxies/test-target-http-proxy",
                    "urlMap" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/urlMaps/test-url-map"
                  }
                },
                :url_maps => {
                  "test-url-map" => {
                    "kind" => "compute#urlMap",
                    "id" => "1361932147851415729",
                    "creationTimestamp" => '2014-08-23T10:06:13.951-07:00',
                    "name" => 'test-url-map',
                    "description" => '',
                    "hostRules" => [],
                    "pathMatchers" => [],
                    "tests" => [],
                    "defaultService" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/backendServices/fog-backend-service-test",
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/urlMaps/test-url-map"
                  }
                },
                :target_pools => {
                  "test-target-pool" => {
                    'kind' => "compute#targetPool",
                    "id" => "1361932147851415729",
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/us-central1/targetPools/test-target-pool",
                    "creationTimestamp" => '2014-08-23T10:06:13.951-07:00',
                    'name' => "test-target-pool",
                    "region" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/us-central1",
                    "healthChecks" => ["https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/httpHealthChecks/test-check"],
                    "instances" => ["https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/us-central1-a/instances/test-instance"],
                  }
                },

                :http_health_checks => {
                  "test-http-health-check" => {
                    "checkIntervalSec" => 5,
                    "creationTimestamp" => '2014-08-23T10:06:13.951-07:00',
                    "healthyThreshold" => 2,
                    "id" => "1361932147851415729",
                    "kind" => "compute#httphealthCheck",
                    "name" => "test-http-health-check",
                    "port" => 80,
                    "requestPath" => '/',
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/httpHealthChecks/test-http-health-check",
                    "timeoutSec" => 5,
                    "unhealthyThreshold" => 2
                  }
                },
                :global_forwarding_rules => {
                  "test-global-forwarding-rule" => {
                    "kind" => "compute#forwardingRule",
                    "id" => "1361932147851415729",
                    "creationTimestamp" => '2014-08-23T10:06:13.951-07:00',
                    "name" => 'test-global-forwarding-rule',
                    "IPAddress" => '107.178.255.155',
                    "IPProtocol" => 'TCP',
                    "portRange" => '80-80',
                    "target" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/targetHttpProxies/proxy",
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/forwardngRules/test-global-forwarding-rule"
                  }
                },
                :forwarding_rules => {
                  "test-forwarding-rule" => {
                    "kind" => "compute#forwardingRule",
                    "id" => "1361932147851415729",
                    "creationTimestamp" => '2014-08-23T10:06:13.951-07:00',
                    "name" => 'test-forwarding-rule',
                    "IPAddress" => '107.178.255.155',
                    "IPProtocol" => 'TCP',
                    "portRange" => '80-80',
                    "target" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/us-central1/targetPools/target_pool",
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/us-central1/forwardngRules/test-forwarding-rule",
                    "region" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/us-central1"
                  }
                },
                :target_instances => {
                  "test-target-instance" => {
                    "kind" => "compute#targetInstance",
                    "name" => "test-target-instance",
                    "natPolicy" => "NO_NAT",
                    "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/us-central1-a",
                    "instance" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/us-central1-a/instances/test-instance",
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/us-central1-a/targetInstances/test-target-instance",
                    "id" => "1361932147851415729",
                    "creationTimestamp" => '2014-08-23T10:06:13.951-07:00',

                  }
                },
                :backend_services =>{
                  "test-backend-service" => {
                    "kind" => "compute#backend_service",
                    "id" => "1361932147851415729",
                    "creationTimestamp" => '2014-08-23T10:06:13.951-07:00',
                    "name" => "test-backend-service",
                    "description" => '',
                    "backends" => [
                       {
                      "description" => '',
                      "group" => "https://www.googleapis.com/resourceviews/v1beta1/projects#{@project}/zones/us-central1-a/zoneViews/name",
                      "balancingMode" => "RATE",
                      "capacityScaler" => 1.1,
                      "maxRate" => 0.5,
                    }],
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/backendServices/test-backend-service"
                  }
                },
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
                :regions => {
                  "us-central1" => {
                    "creationTimestamp" => '2014-01-21T10:30:54.895-08:00',
                    "description" => 'us-central1',
                    "id" => '18201118976141502843',
                    "kind" => "compute#region",
                    "name" =>"us-central1",
                    "quotas" => [
                      {"metric" =>"CPUS", "limit" => 1050.0, "usage" => 28.0},
                      {"metric" =>"DISKS_TOTAL_GB", "limit" => 10000.0, "usage" => 292.0},
                      {"metric" =>"STATIC_ADDRESSES", "limit" => 10.0, "usage" => 0.0},
                      {"metric" =>"IN_USE_ADDRESSES", "limit" => 1050.0, "usage" => 30.0},
                      {"metric" =>"SSD_TOTAL_GB", "limit" => 1024.0, "usage" => 0.0}
                    ],
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/regions/us-central1",
                    "status" => "UP",
                    "zones" =>  [ 
                      "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/us-central1-a",
                      "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/us-central1-b",
                      "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/us-central1-f",
                    ]
                  },
                  "europe-west1" => {
                    "creationTimestamp" => '2014-01-21T10:30:54.891-08:00',
                    "description" => 'europe-west1',
                    "id" => '18201118976141502843',
                    "kind" => "compute#region",
                    "name" =>"europe-west1",
                    "quotas" => [
                      {"metric" =>"CPUS", "limit" => 24.0, "usage" => 0.0},
                      {"metric" =>"DISKS_TOTAL_GB", "limit" => 2048.0, "usage" => 0.0},
                      {"metric" =>"STATIC_ADDRESSES", "limit" => 7.0, "usage" => 0.0},
                      {"metric" =>"IN_USE_ADDRESSES", "limit" => 23.0, "usage" => 0.0},
                      {"metric" =>"SSD_TOTAL_GB", "limit" => 1024.0, "usage" => 0.0}
                    ],
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/regions/erope-west1",
                    "status" => "UP",
                    "zones" =>  [ 
                      "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/europe-west1-a",
                      "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/europe-west1-b",
                    ]
                  },
                  "asia-east1" => {
                    "creationTimestamp" => '2014-01-21T10:30:54.895-08:00',
                    "description" => 'asia-east1',
                    "id" => '18201118976141502843',
                    "kind" => "compute#region",
                    "name" =>"asia-east1",
                    "quotas" => [
                      {"metric" =>"CPUS", "limit" => 1050.0, "usage" => 28.0},
                      {"metric" =>"DISKS_TOTAL_GB", "limit" => 10000.0, "usage" => 292.0},
                      {"metric" =>"STATIC_ADDRESSES", "limit" => 10.0, "usage" => 0.0},
                      {"metric" =>"IN_USE_ADDRESSES", "limit" => 1050.0, "usage" => 30.0},
                      {"metric" =>"SSD_TOTAL_GB", "limit" => 1024.0, "usage" => 0.0}
                    ],
                    "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/regions/asia-east1",
                    "status" => "UP",
                    "zones" =>  [ 
                      "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/asia-east1-a",
                      "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/asia-east1-b",
                      "https://www.googleapis.com/compute/#{api_version}/projects/#{key}/zones/asia-east1-c",
                    ]
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
        include Fog::Google::Shared

        attr_accessor :client
        attr_reader :compute

        def initialize(options)
          shared_initialize(options[:google_project], GOOGLE_COMPUTE_API_VERSION, GOOGLE_COMPUTE_BASE_URL)
          options.merge!(:google_api_scope_url => GOOGLE_COMPUTE_API_SCOPE_URLS.join(' '))

          @client = initialize_google_client(options)
          @compute = @client.discovered_api('compute', api_version)
          @resourceviews = @client.discovered_api('resourceviews', 'v1beta1')
        end
      end

      RUNNING = 'RUNNING'
    end
  end
end
