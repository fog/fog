class Brightbox
  module Compute
    module TestSupport
      # image img-9vxqi = Ubuntu Maverick 10.10 server
      IMAGE_IDENTIFER = "img-9vxqi"
    end
    module Formats
      module Struct
        LB_LISTENER = {
          'in'       => Integer,
          'out'      => Integer,
          'protocol' => String
        }
        LB_HEALTHCHECK = {
          'type'           => String,
          'request'        => String,
          'port'           => Integer,
          'interval'       => Integer,
          'timeout'        => Integer,
          'threshold_up'   => Integer,
          'threshold_down' => Integer
        }
      end

      module Nested
        SERVER_TYPE = {
          "name"            => String,
          "cores"           => Integer,
          "created_at"      => String,
          "resource_type"   => String,
          "updated_at"      => String,
          "disk_size"       => Integer,
          "default"         => Fog::Boolean,
          "url"             => String,
          "id"              => String,
          "ram"             => Integer,
          "status"          => String
        }

        ZONE = {
          "handle"          => String,
          "resource_type"   => String,
          "url"             => String,
          "id"              => String
        }

        ACCOUNT = {
          "name"            => String,
          "ram_used"        => Integer,
          "resource_type"   => String,
          "ram_limit"       => Integer,
          "url"             => String,
          "id"              => String,
          "status"          => String,
          "limits_cloudips" => Integer
        }

        INTERFACE = {
          "resource_type"   => String,
          "url"             => String,
          "id"              => String,
          "ipv4_address"    => String,
          "mac_address"     => String
        }

        IMAGE = {
          "name"            => String,
          "created_at"      => String,
          "resource_type"   => String,
          "arch"            => String,
          "url"             => String,
          "id"              => String,
          "description"     => String,
          "source"          => String,
          "status"          => String,
          "owner"           => String
        }
      end

      module Full
        SERVER = {
          'id'              => String,
          'resource_type'   => String,
          'url'             => String,
          'name'            => String,
          'status'          => String,
          'hostname'        => String,
          'created_at'      => String,
          'started_at'      => NilClass,
          'deleted_at'      => NilClass,
          'user_data'       => NilClass,
          'account'         => Brightbox::Compute::Formats::Nested::ACCOUNT,
          'server_type'     => Brightbox::Compute::Formats::Nested::SERVER_TYPE,
          'cloud_ips'       => [],
          'image'           => Brightbox::Compute::Formats::Nested::IMAGE,
          'snapshots'       => [],
          'interfaces'      => [Brightbox::Compute::Formats::Nested::INTERFACE],
          'zone'            => Brightbox::Compute::Formats::Nested::ZONE
        }

        LOAD_BALANCER = {
          'id'                  => String,
          'resource_type'       => String,
          'url'                 => String,
          'name'                => String,
          'status'              => String,
          'listeners'           => [Brightbox::Compute::Formats::Struct::LB_LISTENER],
          'policy'              => String,
          'healthcheck'         => Hash,
          'created_at'          => String,
          'deleted_at'          => NilClass,
          'account'             => Hash,
          'nodes'               => [Hash]
        }

      end

      module Collected
        SERVER = {
          'id'              => String,
          'resource_type'   => String,
          'url'             => String,
          'name'            => String,
          'status'          => String,
          'hostname'        => String,
          'created_at'      => String,
          'started_at'      => NilClass,
          'deleted_at'      => NilClass, # String (if deleted) OR NilClass
          'account'         => Brightbox::Compute::Formats::Nested::ACCOUNT,
          'server_type'     => Brightbox::Compute::Formats::Nested::SERVER_TYPE,
          'cloud_ips'       => [],
          'image'           => Brightbox::Compute::Formats::Nested::IMAGE,
          'snapshots'       => [],
          'interfaces'      => [Brightbox::Compute::Formats::Nested::INTERFACE],
          'zone'            => Brightbox::Compute::Formats::Nested::ZONE
        }

        LOAD_BALANCER = {
          'id'                  => String,
          'resource_type'       => String,
          'url'                 => String,
          'name'                => String,
          'status'              => String,
          'created_at'          => String,
          'deleted_at'          => NilClass
        }

      end

      module Collection
        SERVERS = [Brightbox::Compute::Formats::Collected::SERVER]
        LOAD_BALANCERS = [Brightbox::Compute::Formats::Collected::LOAD_BALANCER]
      end

    end
  end
end