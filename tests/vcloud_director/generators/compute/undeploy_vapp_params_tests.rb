Shindo.tests('Compute::VcloudDirector | UndeployVAppParams generator', ['vclouddirector', 'xsd']) do

  require 'fog/vcloud_director/generators/compute/undeploy_vapp_params'

  tests('with :UndeployPowerAction option') do
    tests('#to_xml').returns(String) do
      attrs = {:UndeployPowerAction => 'default'}
      @undeploy_vapp_params = Fog::Generators::Compute::VcloudDirector::UndeployVappParams.new(attrs)
      @undeploy_vapp_params.to_xml.class
    end

    tests('#validate').returns([]) do
      pending unless VcloudDirector::Generators::Helpers.have_xsd?
      VcloudDirector::Generators::Helpers.validate(@undeploy_vapp_params.doc)
    end
  end

  tests('without :UndeployPowerAction option') do
    tests('#to_xml').returns(String) do
      attrs = {}
      @undeploy_vapp_params = Fog::Generators::Compute::VcloudDirector::UndeployVappParams.new(attrs)
      @undeploy_vapp_params.to_xml.class
    end

    tests('#validate').returns([]) do
      pending unless VcloudDirector::Generators::Helpers.have_xsd?
      VcloudDirector::Generators::Helpers.validate(@undeploy_vapp_params.doc)
    end
  end

end
