module Fog
  module Compute
    class Ecloud
      class BackupInternetService < Fog::Ecloud::Model

        identity :href, :aliases => :Href

        ignore_attributes :xmlns, :xmlns_i

        attribute :name, :aliases => :Name
        attribute :id, :aliases => :Id
        attribute :protocol, :aliases => :Protocol
        attribute :enabled, :aliases => :Enabled
        attribute :description, :aliases => :Description
        attribute :timeout, :aliases => :Timeout
        attribute :redirect_url, :aliases => :RedirectURL
        attribute :monitor, :aliases => :Monitor

        def delete
          requires :href

          connection.delete_internet_service( href )
        end

        def monitor=(new_monitor = {})
          if new_monitor.nil? || new_monitor.empty?
            attributes[:monitor] = nil
          end
        end

        def save
          if new_record?
            result = connection.add_backup_internet_service( collection.href, _compose_service_data )
            merge_attributes(result.body)
          else
            connection.configure_backup_internet_service( href, _compose_service_data )
          end
        end

        def nodes
          @nodes ||= Fog::Compute::Ecloud::Nodes.new( :connection => connection, :href => href + "/nodeServices" )
        end

        private

        def _compose_service_data
          #For some reason inject didn't work
          service_data = {}
          self.class.attributes.select{ |attribute| !send(attribute).nil? }.each { |attribute| service_data[attribute] = send(attribute) }
          service_data
        end

      end
    end
  end
end
