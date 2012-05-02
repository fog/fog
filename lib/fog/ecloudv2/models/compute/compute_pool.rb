module Fog
  module Compute
    class Ecloudv2
      class ComputePool < Fog::Model

        identity :href

        attribute :href, :aliases => :Href
        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :all_servers, :aliases => :VirtualMachines
        attribute :purchased, :aliases => :Purchased
        attribute :cpu_burst, :aliases => :CpuBurst
        attribute :memory_burst, :aliases => :MemoryBurst

        def servers
          @servers ||= Fog::Compute::Ecloudv2::Servers.new( :connection => connection, :href => "/cloudapi/ecloud/virtualMachines/computePools/#{id}" )
        end

        def layout
          @layout ||= Fog::Compute::Ecloudv2::Layouts.new(:connection => connection, :href => "/cloudapi/ecloud/layout/computePools/#{id}").first
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
