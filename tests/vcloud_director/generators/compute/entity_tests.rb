Shindo.tests('Compute::VcloudDirector | generator | Entity', ['vclouddirector', 'xsd']) do

  require 'fog/vcloud_director/generators/compute/entity'

  NAME = 'NAME'
  HREF = 'HREF'
  TYPE = 'TYPE'
  OPERATION_KEY = 'OPERATION_KEY' # since 5.1
  DESCRIPTION = 'DESCRIPTION'

  tests('#to_xml').returns(String) do
    @element = Fog::Generators::Compute::VcloudDirector::Entity.new(
      NAME,
      :href => HREF, :type => TYPE, :operationKey => OPERATION_KEY,
      :Description => DESCRIPTION)
    @element.to_xml.class
  end
  tests('#data.empty?').returns(true) { $stderr.puts @element.data.inspect; @element.data.empty? }

  tests('#validate').returns([]) do
    pending unless VcloudDirector::Generators::Helpers.have_xsd?
    VcloudDirector::Generators::Helpers.validate(@element.doc)
  end

  tests('#attributes') do
    attributes = @element.doc.root.attributes
    tests('#name').returns(NAME) { attributes['name'].value }
    tests('#href').returns(HREF) { attributes['href'].value }
    tests('#type').returns(TYPE) { attributes['type'].value }
    tests('#operationKey').returns(OPERATION_KEY) { attributes['operationKey'].value }
  end

end
