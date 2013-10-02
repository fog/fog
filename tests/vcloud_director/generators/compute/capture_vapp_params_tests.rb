Shindo.tests('Compute::VcloudDirector | CaptureVAppParams generator', ['vclouddirector', 'xsd']) do

  require 'fog/vcloud_director/generators/compute/capture_vapp_params'

  tests('#to_xml').returns(String) do
    @capture_vapp_params = Fog::Generators::Compute::VcloudDirector::CaptureVappParams.new(
      'name', 'http://example.com/api/vApp/0'
    )
    @capture_vapp_params.to_xml.class
  end

  tests('#validate').returns([]) do
    pending unless VcloudDirector::Generators::Helpers.have_xsd?
    VcloudDirector::Generators::Helpers.validate(@capture_vapp_params.doc)
  end

end
