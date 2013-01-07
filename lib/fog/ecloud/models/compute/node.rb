module Fog
  module Compute
    class Ecloud
      class Node < Fog::Ecloud::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :ip_address, :aliases => :IpAddress
        attribute :protocol, :aliases => :Protocol
        attribute :port, :aliases => :Port, :type => :integer
        attribute :enabled, :aliases => :Enabled, :type => :boolean
        attribute :description, :aliases => :Description

        def ready?
          !self.name.nil?
        end

        def tasks
          @tasks ||= Fog::Compute::Ecloud::Tasks.new(:service => service, :href => "/cloudapi/ecloud/tasks/virtualMachines/#{id}")
        end

        def delete
          data = service.node_service_delete(href).body
          self.service.tasks.new(data)
        end

        def edit(options)
          options[:uri] = href
          options[:description] ||= ""
          options = {:name => name}.merge(options)
          data = service.node_service_edit(options).body
          task = Fog::Compute::Ecloud::Tasks.new(:service => service, :href => data[:href])[0]
        end

        def id
          href.scan(/\d+/)[0]
        end

        alias destroy delete
      end
    end
  end
end
