Shindo.tests('Compute::VcloudDirector | generator | ParamsType', ['vclouddirector', 'xsd']) do

  require 'fog/vcloud_director/generators/compute/params_type'

  NAME = 'NAME'

  tests('#to_xml').returns(String) do
    @type = Fog::Generators::Compute::VcloudDirector::ParamsType.new(
      :name => NAME
    )
    @type.to_xml.class
  end
  tests('#data.empty?').returns(true) { @type.data.empty? }

  tests('#attributes') do
    attributes = @type.doc.root.attributes
    tests('#name').returns(NAME) { attributes['name'].value }
  end

end
