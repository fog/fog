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
          @tasks = Fog::Compute::Ecloud::Tasks.new(:service => service, :href => href)
        end

        def internet_services
          @internet_services = Fog::Compute::Ecloud::InternetServices.new(:service => service, :href => href)
        end

        def node_services
          @node_services = Fog::Compute::Ecloud::NodeServices.new(:service => service, :href => href)
        end

        def edit(options)
          options[:uri] = href
          data = service.backup_internet_service_edit(options).body
          object = collection.from_data(data)
        end

        def delete
          data = service.backup_internet_service_delete(href).body
          task = Fog::Compute::Ecloud::Tasks.new(:service => service, :href => data[:href])[0]
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
