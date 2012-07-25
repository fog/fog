module Fog
  module Compute
    class Ecloud
      class BackupInternetService < Fog::Ecloud::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :protocol, :aliases => :Protocol
        attribute :enabled, :aliases => :Enabled, :type => :boolean 
        attribute :description, :aliases => :Description
        attribute :persistence, :aliases => :Persistence
        attribute :redirect_url, :aliases => :RedirectUrl

        def tasks
          @tasks = Fog::Compute::Ecloud::Tasks.new(:connection => connection, :href => href)
        end

        def internet_services
          @internet_services = Fog::Compute::Ecloud::InternetServices.new(:connection => connection, :href => href)
        end

        def node_services
          @node_services = Fog::Compute::Ecloud::NodeServices.new(:connection => connection, :href => href)
        end

        def edit(options)
          options[:uri] = href
          data = connection.backup_internet_service_edit(options).body
          object = collection.from_data(data)
        end

        def delete
          data = connection.backup_internet_service_delete(href).body
          task = Fog::Compute::Ecloud::Tasks.new(:connection => connection, :href => data[:href])[0]
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
