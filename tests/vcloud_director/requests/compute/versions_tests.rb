Shindo.tests('Compute::VcloudDirector | versions requests', ['vclouddirector']) do

  SUPPORTED_VERSIONS_FORMAT = {
    :xmlns => 'http://www.vmware.com/vcloud/versions',
    :xmlns_xsi => 'http://www.w3.org/2001/XMLSchema-instance',
    :xsi_schemaLocation => String,
    :VersionInfo => [{
      :Version => String,
      :LoginUrl => String,
      :MediaTypeMapping => [{
        :MediaType => String,
        :ComplexTypeName => String,
        :SchemaLocation => String
      }]
    }]
  }

  @service = Fog::Compute::VcloudDirector.new

  tests('#get_supported_versions').formats(SUPPORTED_VERSIONS_FORMAT) do
    @versions = @service.get_supported_versions.body
  end

  tests('API 5.1 is supported').returns(true) do
    !!@versions[:VersionInfo].detect {|i| i[:Version] == '5.1'}
  end

end
