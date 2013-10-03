Shindo.tests('Compute::VcloudDirector | vdc requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('Get current organization') do
    session = @service.get_current_session.body
    link = session[:Link].detect do |l|
      l[:type] == 'application/vnd.vmware.vcloud.org+xml'
    end
    @org = @service.get_organization(link[:href].split('/').last).body
  end

  tests('#get_vdc').data_matches_schema(VcloudDirector::Compute::Schema::VDC_TYPE) do
    link = @org[:Link].detect do |l|
      l[:rel] == 'down' && l[:type] == 'application/vnd.vmware.vcloud.vdc+xml'
    end
    vdc = @service.get_vdc(link[:href].split('/').last).body
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
