class Bluebox
  module BLB
    module Formats
      LB_APPLICATION = {
        'id' => String,
        'ip_v4' => String,
        'ip_v6' => String,
        'name'  => String,
        'lb_services' => Array,
        'source_ip_v4' => Fog::Nullable::String,
      }

      LB_APPLICATIONS = [LB_APPLICATION]

      LB_SERVICE = {
        'name' => String,
        'port' => Integer,
        'private' => Fog::Boolean,
        'status_username' => String,
        'status_password' => String,
        'status_url' => String,
        'service_type' => String,
        'created' => String,
        'lb_backends' => Array,
        'pem_file_uploaded?' => Fog::Nullable::Boolean,
      }

      LB_SERVICES = [LB_SERVICE]

      LB_BACKEND = {
        'id' => String,
        'backend_name' => String,
        'lb_machines' => Array,
        'acl_name' => String,
        'acl_name' => String,
        'monitoring_url_hostname' => String,
        'monitoring_url' => String,
        'monitoring_url_hostname' => String,
        'check_interval' => Integer,
        'rise' => Fog::Nullable::Integer,
        'order' => Fog::Nullable::Integer,
        'fall' => Fog::Nullable::Integer,
      }

      LB_BACKENDS = [LB_BACKEND]

      LB_MACHINE = {
        'port' => Integer,
        'id' => String,
        'ip' => String,
        'maxconn' => Integer,
        'hostname' => String,
        'created' => String,
      }

      ADD_MACHINE_TO_LB = [
        { 'text' => String },
        { 'status' => String },
      ]

      REMOVE_MACHINE_FROM_BACKEND = 'Record Removed.'
    end
  end
end
