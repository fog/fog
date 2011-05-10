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
          "domain" => String
        }
        #SERVICE_OFFERINGS = [Ninefold::Compute::Formats::Lists::SERVICE_OFFERING]
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
        SERVICE_OFFERINGS = [{
                               "id"=>Integer,
                               "name"=>String,
                               "displaytext"=>String,
                               "cpunumber"=>Integer,
                               "cpuspeed"=>Integer,
                               "memory"=>Integer,
                               "created"=>String,
                               "storagetype"=>String,
                               "offerha"=>Fog::Boolean,
                               "domainid"=>Integer,
                               "domain"=>String
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
        PENDING_VIRTUAL_MACHINE = {"id" => Integer, "jobid" => Integer}
        ASYNC_VIRTUAL_MACHINE = {"jobid" => Integer}
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
          "securitygroup"=>Array,
          "nic"=>[{
                    "id"=>Integer,
                    "networkid"=>Integer,
                    "netmask"=>String,
                    "gateway"=>String,
                    "ipaddress"=>String,
                    "traffictype"=>String,
                    "type"=>String,
                    "isdefault"=>Fog::Boolean,
                  }],
          "hypervisor"=>String,
          "cpuused"=>String,
          "networkkbsread"=>Integer,
          "networkkbswrite"=>Integer
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
                    "broadcasturi"=>String,
                    "dns1"=>String,
                    "dns2"=>String,
                    "type"=>String,
                    "account"=>String,
                    "domainid"=>Integer,
                    "domain"=>String,
                    "isdefault"=>Fog::Boolean,
                    "service"=>Array,
                    "networkdomain"=>String,
                    "securitygroupenabled"=>Fog::Boolean
                    }]
      end
    end
  end
end
