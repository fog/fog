module Fog
  module Softlayer
    module Nullable
      module Account; end
      module BareMetal; end
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

      module Collection
        ## nothing here yet
      end
    end
  end
end
