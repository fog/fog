Shindo.tests('Compute::VcloudDirector | generator | UndeployVAppParams', ['vclouddirector', 'xsd']) do

  require 'fog/vcloud_director/generators/compute/undeploy_vapp_params'

  tests('without :UndeployPowerAction option') do
    tests('#to_xml').returns(String) do
      @element = Fog::Generators::Compute::VcloudDirector::UndeployVAppParams.new
      @element.to_xml.class
    end
    tests('#data.empty?').returns(true) { @element.data.empty? }

    tests('#validate').returns([]) do
      pending unless VcloudDirector::Generators::Helpers.have_xsd?
      VcloudDirector::Generators::Helpers.validate(@element.doc)
    end
  end

  tests('with :UndeployPowerAction option') do
    tests('#to_xml').returns(String) do
      @element = Fog::Generators::Compute::VcloudDirector::UndeployVAppParams.new(
        :UndeployPowerAction => 'default'
      )
      @element.to_xml.class
    end
    tests('#data.empty?').returns(true) { @element.data.empty? }

    tests('#validate').returns([]) do
      pending unless VcloudDirector::Generators::Helpers.have_xsd?
      VcloudDirector::Generators::Helpers.validate(@element.doc)
    end
  end

end
