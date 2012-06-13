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

        def tasks
          @tasks ||= Fog::Compute::Ecloud::Tasks.new(:connection => connection, :href => "/cloudapi/ecloud/tasks/virtualMachines/#{id}")
        end

        def delete
          data = connection.node_service_delete(href).body
          task = Fog::Compute::Ecloud::Tasks.new(:connection => connection, :href => data[:href])[0]
        end

        def edit(options)
          options[:uri] = href
          options[:description] ||= ""
          options = {:name => name}.merge(options)
          data = connection.node_service_edit(options).body
          task = Fog::Compute::Ecloud::Tasks.new(:connection => connection, :href => data[:href])[0]
        end
        
        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
