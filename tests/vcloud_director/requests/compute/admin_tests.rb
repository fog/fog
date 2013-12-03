Shindo.tests('Compute::VcloudDirector | admin requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('#get_vcloud').data_matches_schema(VcloudDirector::Compute::Schema::VCLOUD_TYPE) do
     @service.get_vcloud.body
  end

  @org = VcloudDirector::Compute::Helper.current_org(@service)

  tests('#get_org_settings').returns(Hash) do
    pending if Fog.mocking?
    @service.get_org_settings(@org[:href].split('/').last).body.class
  end

end
