module Fog
  module Compute
    class Ecloud
      class ComputePool < Fog::Ecloud::Model

        identity :href

        attribute :href,         :aliases => :Href
        attribute :name,         :aliases => :Name
        attribute :type,         :aliases => :Type
        attribute :other_links,  :aliases => :Links, :squash => :Link
        attribute :all_servers,  :aliases => :VirtualMachines
        attribute :purchased,    :aliases => :Purchased
        attribute :cpu_burst,    :aliases => :CpuBurst
        attribute :memory_burst, :aliases => :MemoryBurst

        def servers
          @servers ||= Fog::Compute::Ecloud::Servers.new( :service => service, :href => "/cloudapi/ecloud/virtualMachines/computePools/#{id}" )
        end

        def layout
          @layout ||= Fog::Compute::Ecloud::Layouts.new(:service => service, :href => "/cloudapi/ecloud/layout/computePools/#{id}").first
        end

        def cpu_usage
#          time ? query = "/details?time=#{Time.parse(time).utc.strftime('%Y-%m-%dT%H:%M:%SZ')}" : query = ""
          @cpu_usage ||= Fog::Compute::Ecloud::CpuUsageDetailSummary.new(:service => service, :href => "/cloudapi/ecloud/computePools/#{id}/usage/cpu")
        end

        def memory_usage
#          time ? query = "/details?time=#{Time.parse(time).utc.strftime('%Y-%m-%dT%H:%M:%SZ')}" : query = ""
          @memory_usage ||= Fog::Compute::Ecloud::MemoryUsageDetailSummary.new(:service => service, :href => "/cloudapi/ecloud/computePools/#{id}/usage/memory")
        end

        def storage_usage
          @storage_usage ||= Fog::Compute::Ecloud::StorageUsageDetailSummary.new(:service => service, :href => "/cloudapi/ecloud/computePools/#{id}/usage/storage")
        end

        def operating_system_families
          @operating_system_families ||= Fog::Compute::Ecloud::OperatingSystemFamilies.new(:service => service, :href => "/cloudapi/ecloud/operatingSystemFamilies/computePools/#{id}")
        end

        def templates
          @templates ||= self.service.templates(:href => "/cloudapi/ecloud/templates/computePools/#{id}")
        end

        def detached_disks
          @detached_disks ||= self.service.detached_disks(:href => "/cloudapi/ecloud/detacheddisks/computepools/#{id}")
        end

        def environment
          @environment ||= begin
                             reload unless other_links
                             environment_link = other_links.find{|l| l[:type] == "application/vnd.tmrk.cloud.environment"}
                             self.service.environments.get(environment_link[:href])
                           end
        end

        def edit(options)
          options[:uri] = href
          data = service.compute_pool_edit(options).body
          pool = collection.from_data(data)
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
