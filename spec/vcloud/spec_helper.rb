require 'spec'
require 'pp'

current_directory = File.dirname(__FILE__)
require "#{current_directory}/../../lib/fog"
require "#{current_directory}/../../lib/fog/bin"

Fog.mock!

require "#{current_directory}/../../lib/fog/vcloud/bin"

shared_examples_for "all requests" do
  it { should respond_to :body }
  it { should respond_to :headers }
  it { should have_at_least(1).body }
  it { should have_at_least(0).headers }
end

shared_examples_for "all rel=down vcloud links" do
  it { should be_an_instance_of Struct::VcloudLink }
  specify { subject.rel.should == "down" }
end

shared_examples_for "all vcloud links w/o a rel" do
  it { should be_an_instance_of Struct::VcloudLink }
  specify { subject.rel.should == nil }
end

shared_examples_for "all vcloud catalog links" do
  specify { subject.type.should == "application/vnd.vmware.vcloud.catalog+xml" }
end

shared_examples_for "all tmrk ecloud publicIpList links" do
  specify { subject.type.should == "application/vnd.tmrk.ecloud.publicIpsList+xml" }
end

shared_examples_for "all tmrk ecloud firewallAclList links" do
  specify { subject.type.should == "application/vnd.tmrk.ecloud.firewallAclsList+xml" }
end

shared_examples_for "all tmrk ecloud internetServicesList links" do
  specify { subject.type.should == "application/vnd.tmrk.ecloud.internetServicesList+xml" }
end

shared_examples_for "all vcloud application/xml types" do
  specify { subject.type.should == "application/xml" }
end

shared_examples_for "a vapp type" do
  specify { subject.type.should == "application/vnd.vmware.vcloud.vApp+xml" }
end

shared_examples_for "all vcloud network types" do
  specify { subject.type.should == "application/vnd.vmware.vcloud.network+xml" }
end

shared_examples_for "all login requests" do

  it { should respond_to :login }

  describe "#login" do
    before { @login = @vcloud.login }
    subject { @login }

    it_should_behave_like "all requests"

    its(:headers) { should include "Set-Cookie" }
    its(:headers) { should include "Content-Type" }
    its(:body) { should be_an_instance_of Struct::VcloudOrgList }

    describe "#body" do
      before { @orglist = @login.body }
      subject { @orglist }

      its(:xmlns) { should == "http://www.vmware.com/vcloud/v0.8" }

      it { should have(1).organizations }

      describe "#first" do
        before { @org = @orglist.organizations.first }
        subject { @org }

        it { should be_an_instance_of Struct::VcloudLink }

        its(:href) { should == URI.parse(@mock_organization[:info][:href]) }
        its(:name) { should == @mock_organization[:info][:name] }
        its(:type) { should == "application/vnd.vmware.vcloud.org+xml" }

      end
    end
  end
end

shared_examples_for "it has a vcloud v0.8 xmlns" do
  its(:xmlns) { should == 'http://www.vmware.com/vcloud/v0.8' }
end

shared_examples_for "a request for a resource that doesn't exist" do
  it { should raise_error Excon::Errors::Unauthorized }
end

shared_examples_for "a vdc catalog link" do
  it_should_behave_like "all rel=down vcloud links"
  it_should_behave_like "all vcloud catalog links"
  its(:href) { should == URI.parse(@mock_vdc[:href] + "/catalog") }
end

shared_examples_for "a tmrk vdc" do
  it { should respond_to :links }
  it { should respond_to :networks }
  it { should respond_to :resource_entities }
end

shared_examples_for "a tmrk network link" do
  it_should_behave_like "all vcloud links w/o a rel"
  it_should_behave_like "all vcloud network types"
end

shared_examples_for "the mocked tmrk network links" do
  it { should have(2).networks }

  describe "[0]" do
    subject { @vdc.body.networks[0] }
    it_should_behave_like "a tmrk network link"
    its(:href) { should == URI.parse(@mock_vdc[:networks][0][:href]) }
    its(:name) { should == @mock_vdc[:networks][0][:name] }
  end

  describe "[1]" do
    subject { @vdc.body.networks[1] }
    it_should_behave_like "a tmrk network link"
    its(:href) { should == URI.parse(@mock_vdc[:networks][1][:href]) }
    its(:name) { should == @mock_vdc[:networks][1][:name] }
  end
end

shared_examples_for "the mocked tmrk resource entity links" do
  it { should have(3).resource_entities }

  describe "[0]" do
    subject { @vdc.body.resource_entities[0] }
    it_should_behave_like "a vapp type"
    it_should_behave_like "all vcloud links w/o a rel"
    its(:href) { should == URI.parse(@mock_vdc[:vms][0][:href]) }
    its(:name) { should == @mock_vdc[:vms][0][:name] }
  end
  describe "[1]" do
    subject { @vdc.body.resource_entities[1] }
    it_should_behave_like "a vapp type"
    it_should_behave_like "all vcloud links w/o a rel"
    its(:href) { should == URI.parse(@mock_vdc[:vms][1][:href]) }
    its(:name) { should == @mock_vdc[:vms][1][:name] }
  end
  describe "[2]" do
    subject { @vdc.body.resource_entities[2] }
    it_should_behave_like "a vapp type"
    it_should_behave_like "all vcloud links w/o a rel"
    its(:href) { should == URI.parse(@mock_vdc[:vms][2][:href]) }
    its(:name) { should == @mock_vdc[:vms][2][:name] }
  end
end

Spec::Example::ExampleGroupFactory.register(:vcloud_request, Class.new(Spec::Example::ExampleGroup))
Spec::Example::ExampleGroupFactory.register(:vcloud_model, Class.new(Spec::Example::ExampleGroup))
Spec::Example::ExampleGroupFactory.register(:tmrk_ecloud_request, Class.new(Spec::Example::ExampleGroup))
Spec::Example::ExampleGroupFactory.register(:tmrk_ecloud_model, Class.new(Spec::Example::ExampleGroup))
Spec::Example::ExampleGroupFactory.register(:tmrk_vcloud_request, Class.new(Spec::Example::ExampleGroup))

Spec::Runner.configure do |config|
  config.before(:all) do
    @mock_data = Fog::Vcloud::Mock::DATA
    @mock_version = @mock_data[:versions][0]
    @mock_organization = @mock_data[:organizations][0]
    @mock_vdc = @mock_organization[:vdcs][0]
  end
  config.before(:each, :type => :vcloud_model) do
    @vcloud = Fog::Vcloud.new
  end
  config.before(:each, :type => :vcloud_request) do
    @vcloud = Fog::Vcloud.new
  end
  config.before(:each, :type => :tmrk_ecloud_request) do
    @vcloud = Fog::Vcloud.new(:module => "Fog::Vcloud::Terremark::Ecloud")
  end
  config.before(:each, :type => :tmrk_ecloud_model) do
    @vcloud = Fog::Vcloud.new(:module => "Fog::Vcloud::Terremark::Ecloud")
  end
  config.before(:each, :type => :tmrk_vcloud_request) do
    @vcloud = Fog::Vcloud.new(:module => "Fog::Vcloud::Terremark::Vcloud")
  end
end

Spec::Matchers.define :have_only_these_attributes do |expected|
  match do |actual|
    attributes = actual.instance_variable_get('@attributes')
    attributes.all? { |attribute| expected.include?(attribute) } && ( expected.length == attributes.length )
  end

  failure_message_for_should do |actual|
    msg = "Expected: [#{expected.map{|e| ":#{e}"}.join(", ")}]\n"
    msg += "Got: [#{actual.instance_variable_get('@attributes').map{|a| ":#{a}"}.join(", ")}]"
    msg
  end
end

Spec::Matchers.define :have_identity do |expected|
  match do |actual|
    actual.instance_variable_get('@identity').should == expected
  end

  failure_message_for_should do |actual|
    "Expected: '#{expected}', but got: '#{actual.instance_variable_get('@identity')}'"
  end
end

Spec::Matchers.define :have_members_of_the_right_model do
  match do |actual|
    actual.all? { |member| member.is_a?(actual.model) }
  end
end
