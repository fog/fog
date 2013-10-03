Shindo.tests('Compute::VcloudDirector | Metadata generator', ['vclouddirector', 'xsd']) do

  require 'fog/vcloud_director/generators/compute/metadata'

  @attrs = {:metadata => {'KEY' => 'VALUE'}}

  tests('vCloud API 1.5') do
    tests('#generate_xml').returns(String) do
      @xml = Fog::Generators::Compute::VcloudDirector::MetadataV15.new(@attrs).generate_xml
      @xml.class
    end

    tests('#parse').returns(Nokogiri::XML::Document) do
      @doc = Nokogiri::XML::Document.parse(@xml)
      @doc.class
    end

    tests('#validate').returns([]) do
      pending unless VcloudDirector::Generators::Helpers.have_xsd?
      VcloudDirector::Generators::Helpers.validate(@doc)
    end
  end

  tests('vCloud API 5.1') do
    tests('#generate_xml').returns(String) do
      @xml = Fog::Generators::Compute::VcloudDirector::MetadataV51.new(@attrs).generate_xml
      @xml.class
    end

    tests('#parse').returns(Nokogiri::XML::Document) do
      @doc = Nokogiri::XML::Document.parse(@xml)
      @doc.class
    end

    tests('#validate').returns([]) do
      pending unless VcloudDirector::Generators::Helpers.have_xsd?
      VcloudDirector::Generators::Helpers.validate(@doc)
    end
  end

end
