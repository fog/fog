module Fog
  module Compute
    class Ecloud
      class InternetService < Fog::Ecloud::Model

        identity :href, :aliases => :Href

        ignore_attributes :xmlns, :xmlns_i

        attribute :name, :aliases => :Name
        attribute :id, :aliases => :Id
        attribute :protocol, :aliases => :Protocol
        attribute :port, :aliases => :Port
        attribute :enabled, :aliases => :Enabled
        attribute :description, :aliases => :Description
        attribute :public_ip, :aliases => :PublicIpAddress
        attribute :timeout, :aliases => :Timeout
        attribute :redirect_url, :aliases => :RedirectURL
        attribute :monitor, :aliases => :Monitor
        attribute :backup_service_data, :aliases => :BackupService

        def delete
          requires :href

          connection.delete_internet_service( href )
        end

        def save
          if new_record?
            result = connection.add_internet_service( collection.href, _compose_service_data )
            merge_attributes(result.body)
          else
            connection.configure_internet_service( href, _compose_service_data, _compose_ip_data )
          end
        end

        # disables monitoring for this service
        def disable_monitor
          if self.monitor and self.monitor[:type] == "Disabled"
            raise RuntimeError.new("Monitoring already disabled")
          else
            self.monitor = {:type => "Disabled", :is_enabled => "true"}
            self.save
          end
        end

        # enable default ping monitoring, use monitor= for more exotic forms (ECV & HTTP)
        def enable_ping_monitor
          self.monitor = nil
          self.save
        end

        def monitor=(new_monitor = {})
          if new_monitor.nil? || new_monitor.empty?
            attributes[:monitor] = nil
          elsif new_monitor.is_a?(Hash)
            attributes[:monitor] = {}
            attributes[:monitor][:type] = new_monitor[:MonitorType] || new_monitor[:type]
            attributes[:monitor][:url_send_string] = new_monitor[:UrlSendString] || new_monitor[:url_send_string]
            attributes[:monitor][:http_headers] = new_monitor[:HttpHeader] || new_monitor[:http_headers]
            if attributes[:monitor][:http_headers]
              if attributes[:monitor][:http_headers].is_a?(String)
                attributes[:monitor][:http_headers] = attributes[:monitor][:http_headers].split("\n")
              else
                attributes[:monitor][:http_headers] = attributes[:monitor][:http_headers]
              end
            end
            attributes[:monitor][:receive_string] = new_monitor[:ReceiveString] || new_monitor[:receive_string]
            attributes[:monitor][:interval] = new_monitor[:Interval] || new_monitor[:interval]
            attributes[:monitor][:response_timeout] = new_monitor[:ResponseTimeOut] || new_monitor[:response_timeout]
            attributes[:monitor][:downtime] = new_monitor[:DownTime] || new_monitor[:downtime]
            attributes[:monitor][:retries] = new_monitor[:Retries] || new_monitor[:retries]
            attributes[:monitor][:is_enabled] = new_monitor[:IsEnabled] || new_monitor[:is_enabled]
          else
            raise RuntimeError.new("monitor needs to either be nil or a Hash")
          end
        end

        def nodes
          @nodes ||= Fog::Compute::Ecloud::Nodes.new( :connection => connection, :href => href + "/nodeServices" )
        end

        def backup_service_uri
          if backup_service_data
            backup_service_data[:Href]
          end
        end

        def backup_service_uri=(new_value)
          self.backup_service_data = {
            :Href => new_value
          }
        end

        private

        def _compose_service_data
          #For some reason inject didn't work
          service_data = {}
          self.class.attributes.select{ |attribute| attribute != :backup_service_data }.each { |attribute| service_data[attribute] = send(attribute) }
          service_data[:backup_service_uri] = backup_service_uri
          service_data.reject! {|k, v| v.nil? }
          service_data
        end

        def _compose_ip_data
          if public_ip.nil?
            {}
          else
            { :id => public_ip[:Id], :href => public_ip[:Href], :name => public_ip[:Name] }
          end
        end

      end
    end
  end
end
