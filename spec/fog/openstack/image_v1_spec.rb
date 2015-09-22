require 'fog/openstack/image_v1'

if RUBY_VERSION =~ /1.8/
  require File.expand_path('../shared_context', __FILE__)
else
  require_relative './shared_context'
end

RSpec.describe Fog::Image::OpenStack do

  include_context 'OpenStack specs with VCR'
  before :all do
    setup_vcr_and_service(
        :vcr_directory => 'spec/fog/openstack/image_v1',
        :service_class => Fog::Image::OpenStack::V1
    )
  end

  it 'lists available images' do
    VCR.use_cassette('list_images') do
      @images = @service.images.all
    end
  end
end
