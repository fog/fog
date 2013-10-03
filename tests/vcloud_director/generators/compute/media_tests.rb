Shindo.tests('Compute::VcloudDirector | generator | Media', ['vclouddirector', 'xsd']) do

  require 'fog/vcloud_director/generators/compute/media'

  tests('#to_xml').returns(String) do
    @element = Fog::Generators::Compute::VcloudDirector::Media.new('NAME', 'iso', '0')
    @element.to_xml.class
  end
  tests('#data.empty?').returns(true) { @element.data.empty? }

  tests('#validate').returns([]) do
    pending unless VcloudDirector::Generators::Helpers.have_xsd?
    VcloudDirector::Generators::Helpers.validate(@element.doc)
  end

end
