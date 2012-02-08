module Fog
  module Brightbox
    module Nullable
      module Account; end
      module FirewallPolicy; end
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

Hash.send :include, Fog::Brightbox::Nullable::FirewallPolicy
NilClass.send :include, Fog::Brightbox::Nullable::FirewallPolicy

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
      # Find a suitable image for testing with
      # For speed of server building we're using an empty image
      def self.image_id
        return @image_id unless @image_id.nil?
        images = Fog::Compute[:brightbox].list_images
        raise "No available images!" if images.empty?
        image = images.select {|img| img.size == 0 }.first
        image = images.first if image.nil?
        @image_id = image["id"]
      end

      # Prepare a test server, wait for it to be usable but raise if it fails
      def self.get_test_server
        test_server_options = {:image_id => image_id}
        server = Fog::Compute[:brightbox].servers.create(test_server_options)
        server.wait_for {
          raise "Test server failed to build" if state == "failed"
          ready?
        }
        server
      end

    end
    module Formats
      module Struct
        LB_LISTENER = {
          "in"              => Integer,
          "out"             => Integer,
          "protocol"        => String,
          "timeout"         => Integer
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
          "resource_type"   => String,
          "url"             => String,
          "id"              => String,
          "status"          => String
        }

        API_CLIENT = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "description"     => String,
          "revoked_at"      => Fog::Nullable::String
        }

        CLOUD_IP = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "public_ip"       => String,
          "status"          => String,
          "reverse_dns"     => String
        }

        FIREWALL_POLICY = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "default"         => Fog::Boolean,
          "created_at"      => String,
          "description"     => Fog::Nullable::String
        }

        FIREWALL_RULE = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "source"          => Fog::Nullable::String,
          "source_port"     => Fog::Nullable::String,
          "destination"     => Fog::Nullable::String,
          "destination_port" => Fog::Nullable::String,
          "protocol"        => String,
          "icmp_type_name"  => Fog::Nullable::String,
          "description"     => Fog::Nullable::String
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
          "owner"           => String,
          "username"        => Fog::Nullable::String
        }

        INTERFACE = {
          "resource_type"   => String,
          "url"             => String,
          "id"              => String,
          "ipv4_address"    => String,
          "ipv6_address"    => Fog::Nullable::String,
          "mac_address"     => String
        }

        LOAD_BALANCER = {
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
          "username"        => Fog::Nullable::String
        }

        SERVER_GROUP = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "created_at"      => String,
          "default"         => Fog::Boolean,
          "description"     => Fog::Nullable::String,
          "created_at"      => String
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
          "revoked_at"      => Fog::Nullable::String,
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
          "server"          => Fog::Brightbox::Nullable::Server
        }

        FIREWALL_POLICY = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "description"     => Fog::Nullable::String,
          "default"         => Fog::Boolean,
          "server_group"    => Brightbox::Compute::Formats::Nested::SERVER_GROUP,
          "rules"  => [Brightbox::Compute::Formats::Nested::FIREWALL_RULE]
        }

        FIREWALL_RULE = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "source"          => String,
          "source_port"     => String,
          "destination"     => String,
          "destination_port" => String,
          "protocol"        => String,
          "icmp_type_name"  => String,
          "description"     => Fog::Nullable::String,
          "firewall_policy" => Brightbox::Compute::Formats::Nested::FIREWALL_POLICY
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
          "username"        => Fog::Nullable::String,
          "public"          => Fog::Boolean,
          "official"        => Fog::Boolean,
          "compatibility_mode" => Fog::Boolean,
          "virtual_size"    => Integer,
          "disk_size"       => Integer,
          "min_ram"         => Fog::Nullable::Integer,
          "ancestor"        => Fog::Brightbox::Nullable::Image,
          "username"        => Fog::Nullable::String
        }

        LOAD_BALANCER = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "status"          => String,
          "created_at"      => String,
          "deleted_at"      => Fog::Nullable::String,
          "cloud_ips"       => [Brightbox::Compute::Formats::Nested::CLOUD_IP],
          "account"         => Brightbox::Compute::Formats::Nested::ACCOUNT,
          "listeners"       => [Brightbox::Compute::Formats::Struct::LB_LISTENER],
          "nodes"           => [Brightbox::Compute::Formats::Nested::SERVER]
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
          "server_groups"   => [Brightbox::Compute::Formats::Nested::SERVER_GROUP],
          "snapshots"       => [Brightbox::Compute::Formats::Nested::IMAGE],
          "interfaces"      => [Brightbox::Compute::Formats::Nested::INTERFACE],
          "zone"            => Fog::Brightbox::Nullable::Zone,
          "username"        => Fog::Nullable::String
        }

        SERVER_GROUP = {
          "created_at"      => String,
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "description"     => Fog::Nullable::String,
          "default"         => Fog::Boolean,
          "created_at"      => String,
          "account"         => Brightbox::Compute::Formats::Nested::ACCOUNT,
          "servers"         => [Brightbox::Compute::Formats::Nested::SERVER],
          "firewall_policy" => Fog::Brightbox::Nullable::FirewallPolicy
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
          "cloud_ips_limit" => Integer,
          "cloud_ips_used"  => Integer,
          "load_balancers_limit" => Integer,
          "load_balancers_used" => Integer,
          "library_ftp_host" => String,
          "library_ftp_user" => String,
          "library_ftp_password" => Fog::Nullable::String,
          "verified_telephone" => Fog::Nullable::String,
          "verified_at"     => Fog::Nullable::String,
          "verified_ip"     => Fog::Nullable::String,
          "valid_credit_card" => Fog::Boolean,
          "owner"           => Brightbox::Compute::Formats::Nested::USER,
          "users"           => [Brightbox::Compute::Formats::Nested::USER],
          "clients"         => [Brightbox::Compute::Formats::Nested::API_CLIENT],
          "servers"         => [Brightbox::Compute::Formats::Nested::SERVER],
          "load_balancers"  => [Brightbox::Compute::Formats::Nested::LOAD_BALANCER],
          "cloud_ips"       => [Brightbox::Compute::Formats::Nested::CLOUD_IP],
          "server_groups"   => [Brightbox::Compute::Formats::Nested::SERVER_GROUP],
          "firewall_policies" => [Brightbox::Compute::Formats::Nested::FIREWALL_POLICY],
          "images"          => [Brightbox::Compute::Formats::Nested::IMAGE],
          "zones"           => [Brightbox::Compute::Formats::Nested::ZONE]
        }

        API_CLIENT = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "description"     => String,
          "revoked_at"      => Fog::Nullable::String,
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

        FIREWALL_POLICY = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "description"     => Fog::Nullable::String,
          "default"         => Fog::Boolean,
          "server_group"    => Brightbox::Compute::Formats::Nested::SERVER_GROUP,
          "rules"  => [Brightbox::Compute::Formats::Nested::FIREWALL_RULE]
        }

        FIREWALL_RULE = {
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "source"          => String,
          "source_port"     => String,
          "destination"     => String,
          "destination_port" => String,
          "protocol"        => String,
          "icmp_type_name"  => String,
          "description"     => Fog::Nullable::String
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
          "username"        => Fog::Nullable::String,
          "public"          => Fog::Boolean,
          "official"        => Fog::Boolean,
          "compatibility_mode"   => Fog::Boolean,
          "virtual_size"    => Integer,
          "disk_size"       => Integer,
          "min_ram"         => Fog::Nullable::Integer,
          "ancestor"        => Fog::Brightbox::Nullable::Image,
          "username"        => Fog::Nullable::String
        }

        INTERFACE = {
          "resource_type"   => String,
          "url"             => String,
          "id"              => String,
          "ipv4_address"    => String,
          "ipv6_address"    => Fog::Nullable::String,
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
          "server_groups"   => [Brightbox::Compute::Formats::Nested::SERVER_GROUP],
          "interfaces"      => [Brightbox::Compute::Formats::Nested::INTERFACE],
          "zone"            => Fog::Brightbox::Nullable::Zone,
          "username"        => Fog::Nullable::String
        }

        SERVER_GROUP = {
          "created_at"      => String,
          "id"              => String,
          "resource_type"   => String,
          "url"             => String,
          "name"            => String,
          "description"     => Fog::Nullable::String,
          "default"         => Fog::Boolean,
          "created_at"      => String,
          "account"         => Brightbox::Compute::Formats::Nested::ACCOUNT,
          "servers"         => [Brightbox::Compute::Formats::Nested::SERVER],
          "firewall_policy" => Fog::Brightbox::Nullable::FirewallPolicy
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
          "ssh_key"         => Fog::Nullable::String,
          "messaging_pref"  => Fog::Boolean
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
        FIREWALL_POLICIES = [Brightbox::Compute::Formats::Collected::FIREWALL_POLICY]
        FIREWALL_RULES = [Brightbox::Compute::Formats::Collected::FIREWALL_RULE]
        LOAD_BALANCERS = [Brightbox::Compute::Formats::Collected::LOAD_BALANCER]
        SERVERS = [Brightbox::Compute::Formats::Collected::SERVER]
        SERVER_GROUPS = [Brightbox::Compute::Formats::Collected::SERVER_GROUP]
        SERVER_TYPES = [Brightbox::Compute::Formats::Collected::SERVER_TYPE]
        USERS = [Brightbox::Compute::Formats::Collected::USER]
        ZONES = [Brightbox::Compute::Formats::Collected::ZONE]
      end

    end
  end
end
