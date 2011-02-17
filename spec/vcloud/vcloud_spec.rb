require 'vcloud/spec_helper'

if Fog.mocking?
  describe Fog::Vcloud, :type => :mock_tmrk_ecloud_request do
    subject { @vcloud }

    it { should be_an_instance_of(Fog::Vcloud::Terremark::Ecloud::Mock) }

    it { should respond_to(:default_organization_uri) }

    it { should respond_to(:supported_versions) }

    it { should have_at_least(1).supported_versions }

    its(:default_organization_uri) { should == @mock_organization.href }

  end
end
