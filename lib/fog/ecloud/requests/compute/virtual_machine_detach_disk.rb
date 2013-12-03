module Fog
  module Compute
    class Ecloud
      module Shared

        def build_request_body_detach_disk(options)
          xml = Builder::XmlMarkup.new
          xml.DetachDisk(:name => options[:name]) do
            xml.Description options[:description]
            xml.Disk do
              xml.Index options[:disk][:Index]
            end
          end
        end
      end

      class Real
        def virtual_machine_detach_disk(href, options)
          body = build_request_body_detach_disk(options)
          request(
            :expects => 201,
            :method => 'POST',
            :headers => {},
            :body => body,
            :uri => href,
            :parse => true
          )
        end
      end

      class Mock
        def virtual_machine_detach_disk(href, options)
          server_id        = href.match(/(\d+)/)[1].to_i
          server           = self.data[:servers][server_id]
          compute_pool_id  = server[:compute_pool_id]
          compute_pool     = self.data[:compute_pools][compute_pool_id]
          detached_disk_id = Fog::Mock.random_numbers(6).to_i
          detached_disk    = {
            :id              => detached_disk_id,
            :href            => "/cloudapi/ecloud/detacheddisks/#{detached_disk_id}",
            :name            => options[:name],
            :type            => "application/vnd.tmrk.cloud.detachedDisk",
            :Links => {
              :Link => [
                Fog::Ecloud.keep(compute_pool, :href, :name, :type),
              ],
            },
            :Description => options[:description],
            :LastKnownVirtualMachineConfiguration => Fog::Ecloud.keep(server, :name, :ProcessorCount, :Memory, :OperatingSystem),
            :Type => "Data",
            :Size => {
              :Unit  => "GB",
              :Value => options[:disk][:Size][:Value],
            },
            :Status => "Available",
          }

          server[:HardwareConfiguration][:Disks][:Disk].delete_if { |disk| disk[:Index] == options[:disk][:Index] }

          detached_disk_response = response(:body => detached_disk)

          detached_disk.merge!(:compute_pool_id => compute_pool_id)

          self.data[:detached_disks][detached_disk_id] = detached_disk

          detached_disk_response
        end
      end
    end
  end
end
