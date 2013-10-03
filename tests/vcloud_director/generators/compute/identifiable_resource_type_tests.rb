Shindo.tests('Compute::VcloudDirector | generator | IdentifiableResourceType', ['vclouddirector', 'xsd']) do

  require 'fog/vcloud_director/generators/compute/identifiable_resource_type'

  tests('#to_xml').returns(String) do
    data = {
      :href => 'HREF',
      :type => 'TYPE',
      :operationKey => 'OPERATION_KEY', # since 5.1
    }
    @type = Fog::Generators::Compute::VcloudDirector::IdentifiableResourceType.new(data)
    @type.to_xml.class
  end
  tests('#data.empty?').returns(true) { @type.data.empty? }

  tests('#attributes') do
    attributes = @type.doc.root.attributes
    tests('#href').returns('HREF') { attributes['href'].value }
    tests('#type').returns('TYPE') { attributes['type'].value }
    tests('#operationKey').returns('OPERATION_KEY') { attributes['operationKey'].value }
  end

end
