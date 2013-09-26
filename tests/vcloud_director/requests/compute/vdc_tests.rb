Shindo.tests('Compute::VcloudDirector | vdc requests', ['vclouddirector']) do

  VDC_FORMAT = {
    :xmlns => 'http://www.vmware.com/vcloud/v1.5',
    :xmlns_xsi => 'http://www.w3.org/2001/XMLSchema-instance',
    :status => String,
    :name => String,
    :id => String,
    :type => 'application/vnd.vmware.vcloud.vdc+xml',
    :href => String,
    :xsi_schemaLocation => String,
    :Link => [{
      :rel => String,
      :type => String,
      :href => String
    }],
    :Description => String,
    :AllocationModel => String,
    :ComputeCapacity => {
      :Cpu => {
        :Units => String,
        :Allocated => String,
        :Limit => String,
        :Reserved => String,
        :Used => String,
        :Overhead => String,
      },
      :Memory => {
        :Units => String,
        :Allocated => String,
        :Limit => String,
        :Reserved => String,
        :Used => String,
        :Overhead => String
      }
    },
    :ResourceEntities => {
      :ResourceEntity => [{
        :type => String,
        :name => String,
        :href => String
      }]
    },
    :AvailableNetworks => {
      :Network => [{
        :type => String,
        :name => String,
        :href => String
      }]
    },
    :Capabilities => {
      :SupportedHardwareVersions => {
        :SupportedHardwareVersion => String,
      }
    },
    :NicQuota => String,
    :NetworkQuota => String,
    :UsedNetworkCount => String,
    :VmQuota => String,
    :IsEnabled => String,
    # TODO
    #:VdcStorageProfiles => { # >= 5.1
    #  :VdcStorageProfile => [{
    #    :type => String,
    #    :name => String,
    #    :href => String
    #  }]
    #}
  }

  @service = Fog::Compute::VcloudDirector.new

  tests('#Get current organization') do
    session = @service.get_current_session.body
    org_href = session[:Link].detect {|l| l[:type] == 'application/vnd.vmware.vcloud.org+xml'}[:href]
    @org = @service.get_organization(org_uuid = org_href.split('/')[-1]).body
  end

  tests('#get_vdc').formats(VDC_FORMAT) do
    vdc_href = @org[:Link].detect {|l| l[:type] == 'application/vnd.vmware.vcloud.vdc+xml'}[:href]
    vdc = @service.get_vdc(vdc_href.split('/')[-1]).body
    vdc[:AvailableNetworks][:Network] = [vdc[:AvailableNetworks][:Network]] if vdc[:AvailableNetworks][:Network].is_a?(Hash)
    vdc[:ResourceEntities][:ResourceEntity] = [vdc[:ResourceEntities][:ResourceEntity]] if vdc[:ResourceEntities][:ResourceEntity].is_a?(Hash)
    if vdc.has_key?(:VdcStorageProfiles)
      vdc[:VdcStorageProfiles][:VdcStorageProfile] = [vdc[:VdcStorageProfiles][:VdcStorageProfile]] if vdc[:VdcStorageProfiles][:VdcStorageProfile].is_a?(Hash)
    end
    vdc
  end

end
