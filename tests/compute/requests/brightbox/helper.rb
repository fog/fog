module Fog
  module Brightbox
    module Nullable
      module Account; end
      module Image; end
      module Interface; end
      module LoadBalancer; end
      module Server; end
      module Zone; end
    end
  end
end

Hash.send :include, Fog::Brightbox::Nullable::Account
NilClass.send :include, Fog::Brightbox::Nullable::Account

Hash.send :include, Fog::Brightbox::Nullable::Image
NilClass.send :include, Fog::Brightbox::Nullable::Image

Hash.send :include, Fog::Brightbox::Nullable::Interface
NilClass.send :include, Fog::Brightbox::Nullable::Interface

Hash.send :include, Fog::Brightbox::Nullable::LoadBalancer
NilClass.send :include, Fog::Brightbox::Nullable::LoadBalancer

Hash.send :include, Fog::Brightbox::Nullable::Server
NilClass.send :include, Fog::Brightbox::Nullable::Server

Hash.send :include, Fog::Brightbox::Nullable::Zone
NilClass.send :include, Fog::Brightbox::Nullable::Zone

class Brightbox
  module Compute
    module TestSupport
      # image img-9vxqi = Ubuntu Maverick 10.10 server
      IMAGE_IDENTIFER = "img-9vxqi"
    end
    module Formats
      module Struct
        LB_LISTENER = {
          "in"              => Integer,
          "out"             => Integer,
          "protocol"        => String
        }
        LB_HEALTHCHECK = {
          "type"            => String,
          "request"         => String,
          "port"            => Integer,
          "interval"        => Integer,
          "timeout"         => Integer,
          "threshold_up"    => Integer,
          "threshold_down"  => Integer
        }
      end

      module Nested
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

        API_CLIENT = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "description"     => String
        }

        CLOUD_IP = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "public_ip"       => String,
          "status"          => String,
          "reverse_dns"     => String
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

        INTERFACE = {
          "resource_type"   => String,
          "url"             => String,
          "id"              => String,
          "ipv4_address"    => String,
          "mac_address"     => String
        }

        SERVER = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "status"          => String,
          "hostname"        => String,
          "created_at"      => String,
          "started_at"      => Fog::Nullable::String,
          "deleted_at"      => Fog::Nullable::String
        }

        SERVER_TYPE = {
          "name"            => String,
          "handle"          => Fog::Nullable::String,
          "cores"           => Integer,
          "resource_type"   => String,
          "disk_size"       => Integer,
          "url"             => String,
          "id"              => String,
          "ram"             => Integer,
          "status"          => String
        }

        USER = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "email_address"   => String
        }

        ZONE = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "handle"          => Fog::Nullable::String
        }
      end

      module Collected
        API_CLIENT = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "description"     => String,
          "account"         => Brightbox::Compute::Formats::Nested::ACCOUNT
        }

        CLOUD_IP = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "public_ip"       => String,
          "status"          => String,
          "reverse_dns"     => String,
          "account"         => Brightbox::Compute::Formats::Nested::ACCOUNT,
          "interface"       => Fog::Brightbox::Nullable::Interface,
          "load_balancer"   => Fog::Brightbox::Nullable::LoadBalancer,
          "server"          => Fog::Nullable::String
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
          "source_type"     => String,
          "status"          => String,
          "owner"           => String,
          "public"          => Fog::Boolean,
          "official"        => Fog::Boolean,
          "compatibility_mode" => Fog::Boolean,
          "virtual_size"    => Integer,
          "disk_size"       => Integer,
          "ancestor"        => Fog::Brightbox::Nullable::Image
        }

        LOAD_BALANCER = {
          "cloud_ips"       => Array,
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "status"          => String,
          "created_at"      => String,
          "deleted_at"      => Fog::Nullable::String
        }

        SERVER = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "status"          => String,
          "hostname"        => String,
          "created_at"      => String,
          "started_at"      => Fog::Nullable::String,
          "deleted_at"      => Fog::Nullable::String,
          "account"         => Brightbox::Compute::Formats::Nested::ACCOUNT,
          "server_type"     => Brightbox::Compute::Formats::Nested::SERVER_TYPE,
          "cloud_ips"       => [Brightbox::Compute::Formats::Nested::CLOUD_IP],
          "image"           => Brightbox::Compute::Formats::Nested::IMAGE,
          "snapshots"       => [Brightbox::Compute::Formats::Nested::IMAGE],
          "interfaces"      => [Brightbox::Compute::Formats::Nested::INTERFACE],
          "zone"            => Fog::Brightbox::Nullable::Zone
        }

        SERVER_TYPE = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "handle"          => Fog::Nullable::String,
          "name"            => String,
          "status"          => String,
          "cores"           => Integer,
          "ram"             => Integer,
          "disk_size"       => Integer
        }

        USER = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "email_address"   => String,
          "email_verified"  => Fog::Boolean,
          "accounts"        => [Brightbox::Compute::Formats::Nested::ACCOUNT],
          "default_account" => NilClass
        }

        ZONE = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "handle"          => Fog::Nullable::String
        }
      end

      module Full
        ACCOUNT = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "status"          => String,
          "address_1"       => String,
          "address_2"       => String,
          "city"            => String,
          "county"          => String,
          "postcode"        => String,
          "country_code"    => String,
          "country_name"    => String,
          "vat_registration_number" => Fog::Nullable::String,
          "telephone_number" => String,
          "telephone_verified" => Fog::Boolean,
          "created_at"      => String,
          "ram_limit"       => Integer,
          "ram_used"        => Integer,
          "limits_cloudips" => Integer,
          "library_ftp_host" => String,
          "library_ftp_user" => String,
          "library_ftp_password" => Fog::Nullable::String,
          "owner"           => Brightbox::Compute::Formats::Nested::USER,
          "users"           => [Brightbox::Compute::Formats::Nested::USER],
          "clients"         => [Brightbox::Compute::Formats::Nested::API_CLIENT],
          "servers"         => [Brightbox::Compute::Formats::Nested::SERVER],
          "images"          => [Brightbox::Compute::Formats::Nested::IMAGE],
          "zones"           => [Brightbox::Compute::Formats::Nested::ZONE]
        }

        API_CLIENT = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "description"     => String,
          "secret"          => Fog::Nullable::String,
          "account"         => Brightbox::Compute::Formats::Nested::ACCOUNT
        }

        CLOUD_IP = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "public_ip"       => String,
          "status"          => String,
          "reverse_dns"     => String,
          "account"         => Fog::Brightbox::Nullable::Account,
          "interface"       => Fog::Brightbox::Nullable::Interface,
          "load_balancer"   => Fog::Brightbox::Nullable::LoadBalancer,
          "server"          => Fog::Brightbox::Nullable::Server
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
          "source_type"     => String,
          "status"          => String,
          "owner"           => String, # Account ID not object
          "public"          => Fog::Boolean,
          "official"        => Fog::Boolean,
          "compatibility_mode"   => Fog::Boolean,
          "virtual_size"    => Integer,
          "disk_size"       => Integer,
          "ancestor"        => Fog::Brightbox::Nullable::Image
        }

        INTERFACE = {
          "resource_type"   => String,
          "url"             => String,
          "id"              => String,
          "ipv4_address"    => String,
          "mac_address"     => String,
          "server"          => Brightbox::Compute::Formats::Nested::SERVER
        }

        LOAD_BALANCER = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "status"          => String,
          "listeners"       => [Brightbox::Compute::Formats::Struct::LB_LISTENER],
          "policy"          => String,
          "healthcheck"     => Brightbox::Compute::Formats::Struct::LB_HEALTHCHECK,
          "created_at"      => String,
          "deleted_at"      => Fog::Nullable::String,
          "account"         => Brightbox::Compute::Formats::Nested::ACCOUNT,
          "nodes"           => [Brightbox::Compute::Formats::Nested::SERVER],
          "cloud_ips"       => [Brightbox::Compute::Formats::Nested::CLOUD_IP]
        }

        SERVER = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "status"          => String,
          "hostname"        => String,
          "created_at"      => String,
          "started_at"      => Fog::Nullable::String,
          "deleted_at"      => Fog::Nullable::String,
          "user_data"       => Fog::Nullable::String,
          "console_url"     => Fog::Nullable::String,
          "console_token"   => Fog::Nullable::String,
          "console_token_expires" => Fog::Nullable::String,
          "account"         => Brightbox::Compute::Formats::Nested::ACCOUNT,
          "server_type"     => Brightbox::Compute::Formats::Nested::SERVER_TYPE,
          "cloud_ips"       => [Brightbox::Compute::Formats::Nested::CLOUD_IP],
          "image"           => Brightbox::Compute::Formats::Nested::IMAGE,
          "snapshots"       => [Brightbox::Compute::Formats::Nested::IMAGE],
          "interfaces"      => [Brightbox::Compute::Formats::Nested::INTERFACE],
          "zone"            => Brightbox::Compute::Formats::Nested::ZONE
        }

        SERVER_TYPE = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "handle"          => Fog::Nullable::String,
          "name"            => String,
          "status"          => String,
          "cores"           => Integer,
          "ram"             => Integer,
          "disk_size"       => Integer
        }

        USER = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "email_address"   => String,
          "email_verified"  => Fog::Boolean,
          "accounts"        => [Brightbox::Compute::Formats::Nested::ACCOUNT],
          "default_account" => Fog::Brightbox::Nullable::Account,
          "ssh_key"         => Fog::Nullable::String
        }

        ZONE = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "handle"          => String
        }

      end

      module Collection
        API_CLIENTS = [Brightbox::Compute::Formats::Collected::API_CLIENT]
        CLOUD_IPS = [Brightbox::Compute::Formats::Collected::CLOUD_IP]
        IMAGES = [Brightbox::Compute::Formats::Collected::IMAGE]
        LOAD_BALANCERS = [Brightbox::Compute::Formats::Collected::LOAD_BALANCER]
        SERVERS = [Brightbox::Compute::Formats::Collected::SERVER]
        SERVER_TYPES = [Brightbox::Compute::Formats::Collected::SERVER_TYPE]
        USERS = [Brightbox::Compute::Formats::Collected::USER]
        ZONES = [Brightbox::Compute::Formats::Collected::ZONE]
      end

    end
  end
end
