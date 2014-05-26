Shindo.tests('Compute::VcloudDirector | versions requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('#get_supported_versions').formats(VcloudDirector::Compute::Schema::SUPPORTED_VERSIONS_TYPE) do
    @versions = @service.get_supported_versions.body
  end

  tests('API 5.1 is supported').returns(true) do
    !!@versions[:VersionInfo].find {|i| i[:Version] == '5.1'}
  end

end
