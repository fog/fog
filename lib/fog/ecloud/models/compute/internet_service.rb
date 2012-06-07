module Fog
  module Compute
    class Ecloud
      class InternetService < Fog::Ecloud::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :actions, :aliases => :Actions
        attribute :protocol, :aliases => :Protocol
        attribute :port, :aliases => :Port, :type => :integer
        attribute :enabled, :aliases => :Enabled, :type => :boolean
        attribute :description, :aliases => :Description
        attribute :public_ip, :aliases => :PublicIp
        attribute :persistence, :aliases => :Persistence
        attribute :redirect_url, :aliases => :RedirectUrl
        attribute :trusted_network_group, :aliases => :TrustedNetworkGroup
        attribute :backup_internet_service, :aliases => :BackupInternetService

        def nodes
          @nodes ||= Fog::Compute::Ecloud::Nodes.new(:connection => connection, :href => href)
        end

        def monitors
          @monitors ||= Fog::Compute::Ecloud::Monitors.new(:connection => connection, :href => "/cloudapi/ecloud/internetServices/#{id}/monitor") 
        end

        def save
          if new_record?
            result = connection.internet_service_create( collection.href, _compose_service_data )
            merge_attributes(result.body)
          else
            connection.configure_internet_service( href, _compose_service_data, _compose_ip_data )
          end
        end

        def edit(options)
          options[:uri] = href
          data = connection.internet_service_edit(options).body
          task = Fog::Compute::Ecloud::Tasks.new(:connection => connection, :href => data[:href])[0]
        end

        def delete
          data = connection.internet_service_delete(href).body
          task = Fog::Compute::Ecloud::Tasks.new(:connection => connection, :href => data[:href])[0]
        end

        def create_monitor(options = {})
          options = {:type => :default}.merge(options)
          case options[:type]
          when :default
            data = connection.monitors_create_default(href + "/action/createDefaultMonitor").body
          when :ping
            options[:enabled] ||= true
            options[:uri] = href + "/action/createPingMonitor"
            data = connection.monitors_create_ping(options).body
          when :http
            options[:uri] = href + "/action/createHttpMonitor"
            data = connection.monitors_create_http(options).body
          when :ecv
            options[:uri] = href + "/action/createEcvMonitor"
            data = connection.monitors_create_ecv(options).body
          when :loopback
            data = connection.monitors_create_loopback(href).body
          end
          monitor = Fog::Compute::Ecloud::Monitors.new(:connection => connection, :href => data[:href])
        end

        def disable_monitor
          data = connection.monitors_disable(href + "/action/disableMonitor").body
          task = Fog::Compute::Ecloud::Tasks.new(:connection => connection, :href => data[:href])
        end

        def id
          href.scan(/\d+/)[0]
        end

        private

        def _compose_service_data
          #For some reason inject didn't work
          service_data = {}
          self.class.attributes.select{ |attribute| attribute != :backup_service_data }.each { |attribute| service_data[attribute] = send(attribute) }
          service_data.reject! {|k, v| v.nil? }
          service_data
        end
      end
    end
  end
end
