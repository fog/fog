module Fog
  module Softlayer
    module Nullable
      module Account; end
      module BareMetal; end
      module Collected; end
      module Collection; end
      module VirtualGuest; end
      module Image; end
      module IPV4; end
      module LoadBalancer; end
    end
  end
end

Hash.send :include, Fog::Softlayer::Nullable::Account
NilClass.send :include, Fog::Softlayer::Nullable::Account

Hash.send :include, Fog::Softlayer::Nullable::BareMetal
NilClass.send :include, Fog::Softlayer::Nullable::BareMetal

Hash.send :include, Fog::Softlayer::Nullable::Collected
NilClass.send :include, Fog::Softlayer::Nullable::Collected

Hash.send :include, Fog::Softlayer::Nullable::Collection
NilClass.send :include, Fog::Softlayer::Nullable::Collection

Hash.send :include, Fog::Softlayer::Nullable::VirtualGuest
NilClass.send :include, Fog::Softlayer::Nullable::VirtualGuest

Hash.send :include, Fog::Softlayer::Nullable::Image
NilClass.send :include, Fog::Softlayer::Nullable::Image

Hash.send :include, Fog::Softlayer::Nullable::IPV4
NilClass.send :include, Fog::Softlayer::Nullable::IPV4

Hash.send :include, Fog::Softlayer::Nullable::LoadBalancer
NilClass.send :include, Fog::Softlayer::Nullable::LoadBalancer


class Softlayer
  module Compute
    module Formats
      module Struct
        ## nothing here yet
      end

      module BareMetal
        SERVER = {
            "accountId" =>  String,
            "createDate" => String,
            "dedicatedAccountHostOnlyFlag" => Fog::Nullable::Boolean,
            "domain" => Fog::Nullable::String,
            "fullyQualifiedDomainName" => Fog::Nullable::String,
            "hostname" => Fog::Nullable::String,
            "id" => String,
            "lastPowerStateId" => Fog::Nullable::String,
            "lastVerifiedDate" => Fog::Nullable::String,
            "maxCpu" => Fog::Nullable::String,
            "maxCpuUnits" => String,
            "maxMemory" => Fog::Nullable::String,
            "metricPollDate" => Fog::Nullable::String,
            "modifyDate" => Fog::Nullable::String,
            "startCpus" => Fog::Nullable::String,
            "statusId" => Integer,
            "globalIdentifier" => String
        }

      end

      module VirtualGuest
        SERVER = {
            "accountId" =>  String,
            "createDate" => String,
            "dedicatedAccountHostOnlyFlag" => Fog::Nullable::Boolean,
            "domain" => String,
            "fullyQualifiedDomainName" => Fog::Nullable::String,
            "hostname" => String,
            "id" => String,
            "lastPowerStateId" => Fog::Nullable::String,
            "lastVerifiedDate" => Fog::Nullable::String,
            "maxCpu" => Fog::Nullable::String,
            "maxCpuUnits" => String,
            "maxMemory" => Integer,
            "metricPollDate" => Fog::Nullable::String,
            "modifyDate" => Fog::Nullable::String,
            "startCpus" => Integer,
            "statusId" => Integer,
            "globalIdentifier" => String
        }

      end

      module Collected
        SERVER = {
            :id => Fog::Nullable::Integer,
            :hostname => Fog::Nullable::String,
            :domain => Fog::Nullable::String,
            :fqdn => Fog::Nullable::String,
            :cpu => Fog::Nullable::String,
            :ram => Fog::Nullable,
            :disk => Fog::Nullable::Array,
            :private_ip => Fog::Nullable::String,
            :public_ip => Fog::Nullable::String,
            :flavor_id => Fog::Nullable::String,
            :bare_metal => Fog::Nullable::Boolean,
            :os_code => Fog::Nullable::String,
            :image_id => Hash,
            :ephemeral_storage => Fog::Nullable::Boolean,
            :created_at => Fog::Nullable::Time,
            :last_verified_date => Fog::Nullable::Time,
            :metric_poll_date => Fog::Nullable::Time,
            :modify_date => Fog::Nullable::Time,
            :account_id => Fog::Nullable::Integer,
            :datacenter => Fog::Nullable::String,
            :single_tenant => Fog::Nullable::Boolean,
            :global_identifier => Fog::Nullable::String,
            :hourly_billing_flag => Fog::Nullable::Boolean,
        }
      end

      module Collection
        SERVERS = [Softlayer::Compute::Formats::Collected::SERVER]
      end
    end
  end
end
