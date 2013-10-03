Shindo.tests('Compute::VcloudDirector | generator | ResourceType', ['vclouddirector', 'xsd']) do

  require 'fog/vcloud_director/generators/compute/resource_type'

  HREF = 'HREF'
  TYPE = 'TYPE'

  tests('#to_xml').returns(String) do
    @type = Fog::Generators::Compute::VcloudDirector::ResourceType.new(
      :href => HREF, :type => TYPE
    )
    @type.to_xml.class
  end
  tests('#data.empty?').returns(true) { @type.data.empty? }

end
