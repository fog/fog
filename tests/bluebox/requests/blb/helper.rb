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

      ADD_MACHINE_TO_LB = {
        'status' => String,
        'text' => String,
      }

      REMOVE_MACHINE_FROM_BACKEND = 'Record Removed.'
    end
  end
end
