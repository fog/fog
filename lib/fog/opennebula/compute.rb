require 'fog/opennebula/core'

module Fog
  module Compute
    class OpenNebula < Fog::Service
      requires   :opennebula_endpoint
      recognizes :opennebula_username, :opennebula_password

      model_path 'fog/opennebula/models/compute'
      model       :server
      collection  :servers
      model       :network
      collection  :networks
      model       :flavor
      collection  :flavors
      model       :interface
      collection  :interfaces
      model       :group
      collection  :groups

      request_path 'fog/opennebula/requests/compute'
      request :list_vms
      request :list_groups
      request :list_networks
      request :vm_allocate
      request :vm_destroy
      request :get_vnc_console
      request :vm_resume
      request :vm_suspend
      request :vm_stop
      request :template_pool
      request :vm_disk_snapshot
      request :vm_shutdown
      request :image_pool

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              "vms" => [
                {
                  "onevm_object" => "",
                  "status" => "RUNNING",
                  "state" => "3",
                  "id" => 4,
                  "uuid" => "5",
                  "gid" => "5",
                  "name" => "MockVM",
                  "user" => "MockUser",
                  "group" => "MockGroup",
                  "cpu" => "2",
                  "memory" => "1024",
                  "mac" => "00:01:02:03:04:05",
                  "ip" => "1.1.1.1"
                }
              ],
              "image_pool" => [
                {}
              ],
              "template_pool" => [
                {
                  "content" => %Q{
                    NAME = mock-vm
                    MEMORY = 512
                    VCPU = 1
                    CPU = 1
                  },
                  "id" => 1,
                  "name" => 'mock',
                  "cpu" => 1,
                  "vcpu" => 1,
                  "memory" => 512,
                  "sched_requirements" => 'CPUSPEED > 1000',
                  "sched_rank" => 'FREECPU',
                  "sched_ds_requirements" => "NAME=mock",
                  "sched_ds_rank" => "FREE_MB",
                  "disk" => {},
                  "nic" => {},
                  "os" => {
                    'ARCH' => 'x86_64'
                  },
                  "graphics" => {},
                  "raw" => %|["DATA"=>"<cpu match='exact'><model fallback='allow'>core2duo</model></cpu>", "TYPE"=>"kvm"]|,
                  "context" => {},
                  "user_variables" => {}
                }
              ]
            }
          end
        end

        def self.reset
          @data = nil
        end

        include Collections
        def initialize(options={})
          @opennebula_endpoint = options[:opennebula_endpoint]
          @opennebula_username = options[:opennebula_username]
          @opennebula_password = options[:opennebula_password]
          require 'opennebula'
        end

        def client
          return @client
        end

        def data
          self.class.data[@opennebula_endpoint]
        end

        def reset_data
          self.class.data.delete(@opennebula_endpoint)
        end
      end

      class Real
        include Collections

        def client
          return @client
        end

        def initialize(options={})
          require 'opennebula'
          @client = ::OpenNebula::Client.new("#{options[:opennebula_username]}:#{options[:opennebula_password]}", options[:opennebula_endpoint])
        end
      end
    end
  end
end
