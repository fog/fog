module Fog
  module Compute
    class Ecloud
      module Shared

        def build_request_body_edit_assigned_ips(networks)
          xml = Builder::XmlMarkup.new
          xml.AssignedIpAddresses do
            xml.Networks do
              networks.each do |network|
                xml.Network(:href => network[:href], :type => network[:type]) do
                  xml.IpAddresses do
                    network[:ips].each do |ip|
                      xml.IpAddress ip
                    end
                  end
                end
              end
            end
          end
        end
      end

      class Real

        def virtual_machine_edit_assigned_ips(href, options)
          body = build_request_body_edit_assigned_ips(options)
          request(
            :expects => 202,
            :method => 'PUT',
            :headers => {},
            :body => body,
            :uri => href,
            :parse => true
          )
        end
      end

      class Mock
        def virtual_machine_edit_assigned_ips(href, options)
          server_id       = href.match(/(\d+)/)[1].to_i
          server          = self.data[:servers][server_id]
          options.each do |network|
            network_id     = id_from_uri(network[:href])
            network        = self.data[:networks][network_id]
            options.each.each do |net|
              net[:ips].each do |ip|
                ip = network[:IpAddresses][:IpAddress].detect { |iph| iph[:name] == ip }
                ip[:Host] = {
                  :href => "/clouapi/ecloud/networkhosts/#{server_id}",
                  :name => server[:name],
                  :type => "application/vnd.tmrk.cloud.networkHost"
                }
                ip[:DetectedOn] = {
                  :href => "/clouapi/ecloud/networkhosts/#{server_id}",
                  :name => server[:name],
                  :type => "application/vnd.tmrk.cloud.networkHost"
                }
              end
            end
          end

          task_id = Fog::Mock.random_numbers(10)
          task = {
            :id            => task_id,
            :href          => "/cloudapi/ecloud/tasks/#{task_id}",
            :type          => "application/vnd.tmrk.cloud.task",
            :Operation     => "Delete Server",
            :Status        => "Complete",
            :ImpactedItem  => Fog::Ecloud.keep(server, :name, :href, :type),
            :StartTime     => Time.now.iso8601,
            :CompletedTime => Time.now.iso8601,
            :InitiatedBy   => {},
          }
          self.data[:tasks][task_id] = task

          response(:body =>  task)
        end
      end
    end
  end
end
