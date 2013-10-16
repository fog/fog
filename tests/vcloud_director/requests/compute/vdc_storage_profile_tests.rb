Shindo.tests('Compute::VcloudDirector | vdc_storage_profile requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new
  @org = VcloudDirector::Compute::Helper.current_org(@service)
  @vdc_id = VcloudDirector::Compute::Helper.first_vdc_id(@org)
  @vdc = @service.get_vdc(@vdc_id).body

  @vdc[:VdcStorageProfiles][:VdcStorageProfile].each do |storage_profile|
    @vdc_storage_profile_id = storage_profile[:href].split('/').last

    tests(storage_profile[:name]) do
      tests("#get_vdc_storage_class").data_matches_schema(VcloudDirector::Compute::Schema::VDC_STORAGE_PROFILE_TYPE) do
        @service.get_vdc_storage_class(@vdc_storage_profile_id).body
      end

      tests('#get_vdc_storage_class_metadata').data_matches_schema(VcloudDirector::Compute::Schema::METADATA_TYPE) do
        pending if Fog.mocking?
        @service.get_vdc_storage_class_metadata(@vdc_storage_profile_id).body
      end
    end
  end

  tests('Retrieve non-existent vDC storage profile').raises(Fog::Compute::VcloudDirector::Forbidden) do
    @service.get_vdc_storage_class('00000000-0000-0000-0000-000000000000')
  end

end
