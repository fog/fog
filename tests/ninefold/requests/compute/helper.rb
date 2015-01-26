class Ninefold
  module Compute
    module TestSupport
      # 1CPU, 1.7GB RAM, 160GB Storage
      SERVICE_OFFERING = 67
      # alternate for testing -
      ALT_SERVICE_OFFERING = 68
      # XEN Basic Ubuntu 10.04 Server x64 PV r2.0
      TEMPLATE_ID = 421
      # Sydney
      ZONE_ID = 1
      # Max time to wait for job completion (2 mins)
      MAXWAIT = 2 * 60

      ## Waits for a job, returning the completed jobs payload.
      ## Accepts an integer jobid, or a hash containing a jobid or id.
      def wait_for_job(job)
        job = job['jobid'] || job['id'] unless job.kind_of? Integer
        while Fog::Compute[:ninefold].query_async_job_result(:jobid => job)['jobstatus'] == 0
          sleep 1
        end
        Fog::Compute[:ninefold].query_async_job_result(:jobid => job)
      end
      module_function :wait_for_job
    end
    module Formats
      module Lists
        SERVICE_OFFERING = {
          "id" => Integer,
          "name" => String,
          "displaytext" => String,
          "cpunumber" => Integer,
          "cpuspeed" => Integer,
          "memory" => Integer,
          "created" => String,
          "storagetype" => String,
          "offerha" => Fog::Boolean,
          "domainid" => Integer,
          "domain" => String,
          "issystem" => Fog::Boolean,
          "limitcpuuse" => Fog::Boolean,
          "defaultuse" => Fog::Boolean

        }
        SERVICE_OFFERINGS = [Ninefold::Compute::Formats::Lists::SERVICE_OFFERING]
        ACCOUNTS = [{
                      "id"=>Integer,
                      "name"=>String,
                      "accounttype"=>Integer,
                      "domainid"=>Integer,
                      "domain"=>String,
                      "receivedbytes"=>Integer,
                      "sentbytes"=>Integer,
                      "vmlimit"=>String,
                      "vmtotal"=>Integer,
                      "vmavailable"=>String,
                      "iplimit"=>String,
                      "iptotal"=>Integer,
                      "ipavailable"=>String,
                      "volumelimit"=>String,
                      "volumetotal"=>Integer,
                      "volumeavailable"=>String,
                      "snapshotlimit"=>String,
                      "snapshottotal"=>Integer,
                      "snapshotavailable"=>String,
                      "templatelimit"=>String,
                      "templatetotal"=>Integer,
                      "templateavailable"=>String,
                      "vmstopped"=>Integer,
                      "vmrunning"=>Integer,
                      "state"=>String,
                      "user"=> [{
                                  "id"=>Integer,
                                  "username"=>String,
                                  "firstname"=>String,
                                  "lastname"=>String,
                                  "email"=>String,
                                  "created"=>String,
                                  "state"=>String,
                                  "account"=>String,
                                  "accounttype"=>Integer,
                                  "domainid"=>Integer,
                                  "domain"=>String,
                                  "apikey"=>String,
                                  "secretkey"=>String
                                }]
                    }]
        EVENTS = [{
                    "id"=>Integer,
                    "username"=>String,
                    "type"=>String,
                    "level"=>String,
                    "description"=>String,
                    "account"=>String,
                    "domainid"=>Integer,
                    "domain"=>String,
                    "created"=>String,
                    "state"=>String,
                    "parentid"=>Integer
                  }]
        DISK_OFFERINGS = [{
                            "id"=>Integer,
                            "domainid"=>Integer,
                            "domain"=>String,
                            "name"=>String,
                            "displaytext"=>String,
                            "disksize"=>Integer,
                            "created"=>String,
                            "iscustomized"=>Fog::Boolean,
                            "tags"=>String
                          }]
        CAPABILITIES = {
          "securitygroupsenabled" => Fog::Boolean,
          "cloudstackversion" => String,
          "userpublictemplateenabled" => Fog::Boolean
        }
        HYPERVISORS = [{
                         "name"=>String
                       }]
        ZONES = [{
                   "allocationstate"=>String,
                   "dhcpprovider"=>String,
                   "id"=>Integer,
                   "name"=>String,
                   "networktype"=>String,
                   "securitygroupsenabled"=>Fog::Boolean
                 }]
        NETWORK_OFFERINGS = [{
                               "id"=>Integer,
                               "name"=>String,
                               "displaytext"=>String,
                               "traffictype"=>String,
                               "isdefault"=>Fog::Boolean,
                               "specifyvlan"=>Fog::Boolean,
                               "availability"=>String,
                               "guestiptype"=>String,
                               "networkrate"=>Integer
                             }]
        RESOURCE_LIMITS = [{
                             "account"=>String,
                             "domainid"=>Integer,
                             "domain"=>String,
                             "resourcetype"=>String,
                             "max"=>Integer
                           }]
      end
      module VirtualMachines
        VIRTUAL_MACHINE = {
          "id"=>Integer,
          "name"=>String,
          "displayname"=>String,
          "account"=>String,
          "domainid"=>Integer,
          "domain"=>String,
          "created"=>String,
          "state"=>String,
          "haenable"=>Fog::Boolean,
          "zoneid"=>Integer,
          "zonename"=>String,
          "templateid"=>Integer,
          "templatename"=>String,
          "templatedisplaytext"=>String,
          "passwordenabled"=>Fog::Boolean,
          "serviceofferingid"=>Integer,
          "serviceofferingname"=>String,
          "cpunumber"=>Integer,
          "cpuspeed"=>Integer,
          "memory"=>Integer,
          "guestosid"=>Integer,
          "rootdeviceid"=>Integer,
          "rootdevicetype"=>String,
          "nic"=>[{
                    "id"=>Integer,
                    "networkid"=>Integer,
                    "netmask"=>Fog::Nullable::String,
                    "gateway"=>Fog::Nullable::String,
                    "ipaddress"=>Fog::Nullable::String,
                    "traffictype"=>String,
                    "type"=>String,
                    "isdefault"=>Fog::Boolean,
                  }],
          "hypervisor"=>String,
          "cpuused"=>Fog::Nullable::String,
          "networkkbsread"=>Fog::Nullable::Integer,
          "networkkbswrite"=>Fog::Nullable::Integer
        }
        VIRTUAL_MACHINES = [VIRTUAL_MACHINE]
      end
      module Templates
        TEMPLATES = [{
                      "id"=>Integer,
                       "name"=>String,
                       "displaytext"=>String,
                       "ispublic"=>Fog::Boolean,
                       "created"=>String,
                       "isready"=>Fog::Boolean,
                       "passwordenabled"=>Fog::Boolean,
                       "format"=>String,
                       "isfeatured"=>Fog::Boolean,
                       "crossZones"=>Fog::Boolean,
                       "ostypeid"=>Integer,
                       "ostypename"=>String,
                       "account"=>String,
                       "zoneid"=>Integer,
                       "zonename"=>String,
                       "size"=>Integer,
                       "templatetype"=>String,
                       "hypervisor"=>String,
                       "domain"=>String,
                       "domainid"=>Integer,
                       "isextractable"=>Fog::Boolean,
                     }]
      end
      module Jobs
        JOB = {
          "jobid"=>Integer,
          "accountid"=>Integer,
          "userid"=>Integer,
          "cmd"=>String,
          "jobstatus"=>Integer,
          "jobprocstatus"=>Integer,
          "jobresultcode"=>Integer,
          "jobresult"=>Hash,
          "created"=>String
        }
        JOBS = [JOB]
        JOB_QUERY = {
          "jobid"=>Integer,
          "jobstatus"=>Integer,
          "jobprocstatus"=>Integer,
          "jobresultcode"=>Integer,
          "jobresulttype"=>String,
          "jobresult"=>Hash
        }
      end
      module Networks
        NETWORKS=[{"id"=>Integer,
                    "name"=>String,
                    "displaytext"=>String,
                    "broadcastdomaintype"=>String,
                    "traffictype"=>String,
                    "zoneid"=>Integer,
                    "networkofferingid"=>Integer,
                    "networkofferingname"=>String,
                    "networkofferingdisplaytext"=>String,
                    "networkofferingavailability"=>String,
                    "isshared"=>Fog::Boolean,
                    "issystem"=>Fog::Boolean,
                    "state"=>String,
                    "related"=>Integer,
                    "broadcasturi"=>Fog::Nullable::String,
                    "dns1"=>String,
                    "dns2"=>String,
                    "type"=>String,
                    "account"=>String,
                    "domainid"=>Integer,
                    "domain"=>String,
                    "isdefault"=>Fog::Boolean,
                    "service"=>Array,
                    "networkdomain"=>Fog::Nullable::String,
                    "securitygroupenabled"=>Fog::Boolean,
                    "netmask"=>Fog::Nullable::String,
                    "startip"=>Fog::Nullable::String,
                    "endip"=>Fog::Nullable::String,
                    "gateway"=>Fog::Nullable::String,
                    "vlan"=>Fog::Nullable::String
                    }]
      end
      module Addresses
        ADDRESS = {
          "id"=>Integer,
          "ipaddress"=>String,
          "allocated"=>String,
          "zoneid"=>Integer,
          "zonename"=>String,
          "issourcenat"=>Fog::Boolean,
          "account"=>String,
          "domainid"=>Integer,
          "domain"=>String,
          "forvirtualnetwork"=>Fog::Boolean,
          "isstaticnat"=>Fog::Boolean,
          "associatednetworkid"=>Integer,
          "networkid"=>Integer,
          "state"=>String,
          "virtualmachineid"=>Fog::Nullable::Integer,
          "virtualmachinename"=>Fog::Nullable::String
        }
        ADDRESSES = [ADDRESS]
        DISASSOC_ADDRESS = {"jobid"=>Integer}
      end
      module Nat
        ENABLE_NAT_RESPONSE = {
          'success' => String
        }
        DISABLE_NAT_RESPONSE = {
          'success' => Fog::Boolean
        }
        DELETE_RULE_RESPONSE = {
          'success' => Fog::Boolean
        }
        FORWARDING_RULE = {
          "id"=>Integer,
          "protocol"=>String,
          "virtualmachineid"=>Integer,
          "virtualmachinename"=>String,
          "ipaddressid"=>Integer,
          "ipaddress"=>String,
          "startport"=>Integer,
          "endport"=>Integer,
          "state"=>String
        }
        FORWARDING_RULES = [FORWARDING_RULE]
      end
      module LoadBalancers
        CREATE_LOAD_BALANCER_RULE_RESPONSE = {
          "id"=>Integer,
          "account"=>String,
          "algorithm"=>String,
          "cidrlist"=>String,
          "domain"=>String,
          "domainid"=>Integer,
          "name"=>String,
          "privateport"=>String,
          "publicip"=>String,
          "publicipid"=>Integer,
          "publicport"=>String,
          "state"=>String,
          "zoneid"=>Integer
        }
        ASSIGN_LOAD_BALANCER_RULE_RESPONSE = {
          "success"=>Fog::Boolean
        }
        LIST_LOAD_BALANCER_RULES_RESPONSE = {
          "id"=>Integer,
          "name"=>String,
          "publicipid"=>Integer,
          "publicip"=>String,
          "publicport"=>String,
          "privateport"=>String,
          "algorithm"=>String,
          "cidrlist"=>String,
          "account"=>String,
          "domainid"=>Integer,
          "domain"=>String,
          "state"=>String,
          "zoneid"=>Integer
        }
        UPDATE_LOAD_BALANCER_RULE_RESPONSE = {
          "id"=>Integer,
          "name"=>String,
          "publicipid"=>Integer,
          "publicip"=>String,
          "publicport"=>String,
          "privateport"=>String,
          "algorithm"=>String,
          "cidrlist"=>String,
          "account"=>String,
          "domainid"=>Integer,
          "domain"=>String,
          "state"=>String,
          "zoneid"=>Integer
        }
        REMOVE_FROM_LOAD_BALANCER_RULE_RESPONSE = {
          "success"=>Fog::Boolean
        }
      end
    end
  end
end
