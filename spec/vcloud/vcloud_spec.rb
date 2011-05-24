require 'vcloud/spec_helper'

if Fog.mocking?
  describe Fog::Vcloud, :type => :mock_vcloud_request do
    subject { @vcloud }

    it { should be_an_instance_of(Fog::Vcloud::Compute::Mock) }

    it { should respond_to(:default_organization_uri) }

    its(:default_organization_uri) { should == @mock_organization.href }

  end
end
