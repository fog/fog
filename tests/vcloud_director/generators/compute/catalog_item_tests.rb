Shindo.tests('Compute::VcloudDirector | generator | CatalogItem', ['vclouddirector', 'xsd']) do

  require 'fog/vcloud_director/generators/compute/catalog_item'

  NAME = 'name'
  SOURCE_HREF = 'SOURCE:HREF'

  tests('#to_xml').returns(String) do
    @element = Fog::Generators::Compute::VcloudDirector::CatalogItem.new(NAME, SOURCE_HREF)
    @element.to_xml.class
  end
  tests('#data.empty?').returns(true) { @element.data.empty? }

  tests('#validate').returns([]) do
    pending unless VcloudDirector::Generators::Helpers.have_xsd?
    VcloudDirector::Generators::Helpers.validate(@element.doc)
  end

end
