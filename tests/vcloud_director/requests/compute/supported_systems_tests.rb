Shindo.tests('Compute::VcloudDirector | supported_systems requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  if @service.api_version.to_f >= 5.1
    tests('#get_supported_systems_info').formats(VcloudDirector::Compute::Schema::SUPPORTED_OPERATING_SYSTEMS_INFO_TYPE) do
      @service.get_supported_systems_info.body
    end
  end

end
