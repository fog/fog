module Fog
  module Compute
    class Ecloud
      module Shared

        def build_request_body_attach_disk(options)
          xml = Builder::XmlMarkup.new
          xml.AttachDisks(:name => options[:name]) do
            xml.DetachedDisks do
              xml.DetachedDisk(:href => options[:href], :name => options[:name], :type => "application/vnd.tmrk.cloud.detachedDisk")
            end
          end
        end
      end

      class Real
        def virtual_machine_attach_disk(href, options)
          body = build_request_body_attach_disk(options)
          request(
            :expects => 202,
            :method => 'POST',
            :headers => {},
            :body => body,
            :uri => href,
            :parse => true
          )
        end
      end

      class Mock
        def virtual_machine_attach_disk(href, options)
          server_id        = href.match(/(\d+)/)[1].to_i
          server           = self.data[:servers][server_id]
          compute_pool_id  = server[:compute_pool_id]
          compute_pool     = self.data[:compute_pools][compute_pool_id]
          detached_disk_id = options[:href].match(/(\d+)/)[1].to_i
          detached_disk    = self.data[:detached_disks][detached_disk_id]
          new_index        = (server[:HardwareConfiguration][:Disks][:Disk].map { |h| h[:Index].to_i }.sort.last + 1).to_s
          detached_disk[:Index] = new_index
          server[:HardwareConfiguration][:Disks][:Disk] << Fog::Ecloud.keep(detached_disk, :Index, :Size, :Name)

          self.data[:detached_disks].delete(detached_disk_id)

          task_id = Fog::Mock.random_numbers(10).to_i
          task = {
            :id            => task_id,
            :href          => "/cloudapi/ecloud/tasks/#{task_id}",
            :type          => "application/vnd.tmrk.cloud.task",
            :Operation     => "Attach Disk",
            :Status        => "Complete",
            :ImpactedItem  => Fog::Ecloud.keep(server, :href, :type),
            :StartTime     => Time.now.iso8601,
            :CompletedTime => Time.now.iso8601,
            :InitiatedBy   => {},
          }
          self.data[:tasks][task_id] = task
          response(:body => task)
        end
      end
    end
  end
end
