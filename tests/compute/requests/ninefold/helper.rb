class Ninefold
  module Compute
    module TestSupport
      # image img-9vxqi = Ubuntu Maverick 10.10 server
      IMAGE_IDENTIFER = "img-9vxqi"
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
    end
  end
end
