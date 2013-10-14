Shindo.tests('Compute::VcloudDirector | vdc requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new
  @org = VcloudDirector::Compute::Helper.current_org(@service)

  tests('#get_vdc').data_matches_schema(VcloudDirector::Compute::Schema::VDC_TYPE) do
    link = @org[:Link].detect do |l|
      l[:rel] == 'down' && l[:type] == 'application/vnd.vmware.vcloud.vdc+xml'
    end
    @vdc_id = link[:href].split('/').last
    vdc = @service.get_vdc(@vdc_id).body
    vdc[:AvailableNetworks][:Network] = [vdc[:AvailableNetworks][:Network]] if vdc[:AvailableNetworks][:Network].is_a?(Hash)
    vdc[:ResourceEntities][:ResourceEntity] = [vdc[:ResourceEntities][:ResourceEntity]] if vdc[:ResourceEntities][:ResourceEntity].is_a?(Hash)
    vdc[:VdcStorageProfiles][:VdcStorageProfile] = [vdc[:VdcStorageProfiles][:VdcStorageProfile]] if vdc[:VdcStorageProfiles][:VdcStorageProfile].is_a?(Hash)
    vdc
  end

  tests('#get_vdc_metadata').data_matches_schema(VcloudDirector::Compute::Schema::METADATA_TYPE) do
    pending if Fog.mocking?
    @service.get_vdc_metadata(@vdc_id).body
  end

  tests('#get_vdcs_from_query').data_matches_schema(VcloudDirector::Compute::Schema::CONTAINER_TYPE) do
    pending if Fog.mocking?
    @service.get_vdcs_from_query.body
  end

  tests('Retrieve non-existent vDC').raises(Fog::Compute::VcloudDirector::Forbidden) do
    @service.get_vdc('00000000-0000-0000-0000-000000000000')
  end

end
