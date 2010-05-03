require 'spec_helper'

describe Fog::Vcloud do
  subject { Fog::Vcloud.new() }

  it { should be_an_instance_of Fog::Vcloud::Mock }

  it { should respond_to :default_organization_uri }

  it { should respond_to :supported_versions }

  it { should have_at_least(1).supported_versions }

  its(:default_organization_uri) { should == URI.parse(@mock_organization[:info][:href]) }
  its(:default_organization_uri) { should be_an_instance_of URI::HTTPS }

end
