module Fog
  module Compute
    class Cloudstack
      class Project < Fog::Model
        identity  :id,                  :aliases => 'id'
        attribute :name,                :aliases => 'name'
        attribute :display_text,        :aliases => 'displaytext'
        attribute :domain_id,           :aliases => 'domainid'
        attribute :domain,              :aliases => 'domain'
        attribute :account,             :aliases => 'account'
        attribute :state,               :aliases => 'state'
        attribute :tags,                :aliases => 'tags'
        attribute :network_limit,       :aliases => 'networklimit'
        attribute :network_total,       :aliases => 'networktotal', :type => :integer
        attribute :network_available,   :aliases => 'networkavailable'
        attribute :vpc_limit,           :aliases => 'vpclimit'
        attribute :vpc_total,           :aliases => 'vpctotal', :type => :integer
        attribute :vpc_available,       :aliases => 'vpcavailable'
        attribute :cpu_limit,           :aliases => 'cpulimit'
        attribute :cpu_total,           :aliases => 'cputotal', :type => :integer
        attribute :cpu_available,       :aliases => 'cpuavailable'
        attribute :memory_limit,        :aliases => 'memorylimit'
        attribute :memory_total,        :aliases => 'memorytotal', :type => :integer
        attribute :memory_available,            :aliases => 'memoryavailable'
        attribute :primary_storage_limit,       :aliases => 'primarystoragelimit'
        attribute :primary_storage_total,       :aliases => 'primarystoragetotal', :type => :integer
        attribute :primary_storage_available,   :aliases => 'primarystorageavailable'
        attribute :secondary_storage_limit,     :aliases => 'secondarystoragelimit'
        attribute :secondary_storage_total,     :aliases => 'secondarystoragetotal', :type => :integer
        attribute :secondary_storage_available, :aliases => 'secondarystorageavailable'
        attribute :vm_limit,                    :aliases => 'vmlimit'
        attribute :vm_total,                    :aliases => 'vmtotal', :type => :integer
        attribute :vm_available,                :aliases => 'vmavailable'
        attribute :ip_limit,                    :aliases => 'iplimit'
        attribute :ip_total,                    :aliases => 'iptotal', :type => :integer
        attribute :ip_available,                :aliases => 'ipavailable'
        attribute :volume_limit,                :aliases => 'volumelimit'
        attribute :volume_total,                :aliases => 'volumetotal', :type => :integer
        attribute :volume_available,            :aliases => 'volumeavailable'
        attribute :snapshot_limit,              :aliases => 'snapshotlimit'
        attribute :snapshot_total,              :aliases => 'snapshottotal', :type => :integer
        attribute :snapshot_available,          :aliases => 'snapshotavailable'
        attribute :template_limit,              :aliases => 'templatelimit'
        attribute :template_total,              :aliases => 'templatetotal', :type => :integer
        attribute :template_available,          :aliases => 'templateavailable'

        def save
          raise Fog::Errors::Error.new('Creating a project is not supported')
        end

        def destroy
          raise Fog::Errors::Error.new('Destroying a project is not supported')
        end

      end # Project
    end # Cloudstack
  end # Compute
end # Fog
