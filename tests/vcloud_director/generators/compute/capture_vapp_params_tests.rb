Shindo.tests('Compute::VcloudDirector | generator | CaptureVAppParams', ['vclouddirector', 'xsd']) do

  require 'fog/vcloud_director/generators/compute/capture_vapp_params'

  SOURCE_HREF = 'SOURCE:HREF'
  NAME = 'NAME'

  tests('without :Description') do
    tests('#to_xml').returns(String) do
      @element = Fog::Generators::Compute::VcloudDirector::CaptureVAppParams.new(
        SOURCE_HREF, :name => NAME
      )
      @element.to_xml.class
    end
    tests('#data.empty?').returns(true) { @element.data.empty? }

    tests('#validate').returns([]) do
      pending unless VcloudDirector::Generators::Helpers.have_xsd?
      VcloudDirector::Generators::Helpers.validate(@element.doc)
    end

    tests('#attributes') do
      attributes = @element.doc.root.attributes
      tests('#name').returns(NAME) { attributes['name'].value }
    end

    tests('#elements') do
      pending
    end
  end

  tests('with :Description') do
    DESCRIPTION = 'DESCRIPTION'

    tests('#to_xml').returns(String) do
      @element = Fog::Generators::Compute::VcloudDirector::CaptureVAppParams.new(
        SOURCE_HREF, :name => NAME, :Description => DESCRIPTION
      )
      @element.to_xml.class
    end
    tests('#data.empty?').returns(true) { @element.data.empty? }

    tests('#validate').returns([]) do
      pending unless VcloudDirector::Generators::Helpers.have_xsd?
      VcloudDirector::Generators::Helpers.validate(@element.doc)
    end

    tests('#attributes') do
      attributes = @element.doc.root.attributes
      tests('#name').returns(NAME) { attributes['name'].value }
    end

    tests('#elements') do
      pending
    end
  end

end
