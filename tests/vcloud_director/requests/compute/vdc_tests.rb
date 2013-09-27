Shindo.tests('Compute::VcloudDirector | vdc requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('Get current organization') do
    session = @service.get_current_session.body
    org_href = session[:Link].detect {|l| l[:type] == 'application/vnd.vmware.vcloud.org+xml'}[:href]
    org_uuid = org_href.split('/').last
    @org = @service.get_organization(org_uuid).body
  end

  tests('#get_vdc').data_matches_schema(VcloudDirector::Compute::Schema::VDC_TYPE) do
    vdc_href = @org[:Link].detect {|l| l[:type] == 'application/vnd.vmware.vcloud.vdc+xml'}[:href]
    vdc_uuid = vdc_href.split('/').last
    vdc = @service.get_vdc(vdc_uuid).body
    vdc[:AvailableNetworks][:Network] = [vdc[:AvailableNetworks][:Network]] if vdc[:AvailableNetworks][:Network].is_a?(Hash)
    vdc[:ResourceEntities][:ResourceEntity] = [vdc[:ResourceEntities][:ResourceEntity]] if vdc[:ResourceEntities][:ResourceEntity].is_a?(Hash)
    if vdc.has_key?(:VdcStorageProfiles)
      vdc[:VdcStorageProfiles][:VdcStorageProfile] = [vdc[:VdcStorageProfiles][:VdcStorageProfile]] if vdc[:VdcStorageProfiles][:VdcStorageProfile].is_a?(Hash)
    end
    vdc
  end

  tests('Retrieve non-existent vDC').raises(Excon::Errors::Forbidden) do
    @service.get_vdc('00000000-0000-0000-0000-000000000000')
  end

end
