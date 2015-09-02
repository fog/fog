require 'fog/openstack/compute'
require 'fog/openstack/identity'
require 'fog/openstack/identity_v3'
require 'fog/openstack/network'

if RUBY_VERSION =~ /1.8/
  require File.expand_path('../shared_context', __FILE__)
else
  require_relative './shared_context'
end

RSpec.describe Fog::Network::OpenStack do

  include_context 'OpenStack specs with VCR'
  before :all do
    setup_vcr_and_service(
        :vcr_directory => 'spec/fog/openstack/network',
        :service_class => Fog::Network::OpenStack
    )
  end


  it 'CRUD subnets' do
    VCR.use_cassette('subnets_crud') do
      begin

        foonet = @service.networks.create(:name => 'foo-net12', :shared => false)

        subnet = @service.subnets.create(:name => "my-network", :network_id => foonet.id, :cidr => '172.16.0.0/16', :ip_version => 4, :gateway_ip => nil)

        expect(subnet.name).to eq 'my-network'

      ensure
        subnet.destroy if subnet
        foonet.destroy if foonet
      end

    end
  end



end
