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

        def cpu_usage
#          time ? query = "/details?time=#{Time.parse(time).utc.strftime('%Y-%m-%dT%H:%M:%SZ')}" : query = ""
          @cpu_usage ||= Fog::Compute::Ecloudv2::CpuUsageDetailSummary.new(:connection => connection, :href => "/cloudapi/ecloud/computePools/#{id}/usage/cpu")
        end

        def memory_usage
#          time ? query = "/details?time=#{Time.parse(time).utc.strftime('%Y-%m-%dT%H:%M:%SZ')}" : query = ""
          @memory_usage ||= Fog::Compute::Ecloudv2::MemoryUsageDetailSummary.new(:connection => connection, :href => "/cloudapi/ecloud/computePools/#{id}/usage/memory")
        end

        def storage_usage
          @storage_usage ||= Fog::Compute::Ecloudv2::StorageUsageDetailSummary.new(:connection => connection, :href => "/cloudapi/ecloud/computePools/#{id}/usage/storage")
        end

        def operating_system_families
          @operating_system_families ||= Fog::Compute::Ecloudv2::OperatingSystemFamilies.new(:connection => connection, :href => "/cloudapi/ecloud/operatingSystemFamilies/computePools/#{id}")
        end

        def templates
          @templates ||= Fog::Compute::Ecloudv2::Templates.new(:connection => connection, :href => "/cloudapi/ecloud/templates/computePools/#{id}")
        end

        def edit(options)
          options[:uri] = href
          data = connection.compute_pool_edit(options).body
          pool = collection.from_data(data)
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
