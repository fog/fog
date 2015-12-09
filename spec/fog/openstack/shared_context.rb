require 'rspec/core'
require 'rspec/expectations'
require 'vcr'
require 'fog/openstack/core'
require 'fog/openstack/identity'
require 'fog/openstack/identity_v3'
require 'fog/openstack/image'
require 'fog/openstack/image_v1'
require 'fog/openstack/image_v2'
require 'fog/openstack/volume'
require 'fog/openstack/volume_v1'
require 'fog/openstack/volume_v2'
require 'fog/openstack/network'

#
# There are basically two modes of operation for these specs.
#
# 1. ENV[OS_AUTH_URL] exists: talk to an actual OpenStack and record HTTP
#    traffic in VCRs at "spec/debug" (credentials are read from the conventional
#    environment variables: OS_AUTH_URL, OS_USERNAME, OS_PASSWORD etc.)
# 2. otherwise (under Travis etc.): use VCRs at "spec/fog/openstack/#{service}"
#
# When you develop a new unit test or change an existing one:
#
# 1. Record interactions against an actual OpenStack (Devstack is usually
#    enough if configured correctly) using the first mode from above.
# 2. Move the relevant VCRs from "spec/debug" to
#    "spec/fog/openstack/#{service}".
# 3. In these VCRs, string-replace your OpenStack's URLs/IPs by
#    "devstack.openstack.stack". Also, string-replace the used tokens by the
#    token obtained in the "common_setup.yml".
#
RSpec.shared_context 'OpenStack specs with VCR' do

  # This method should be called in a "before :all" call to set everything up.
  # A properly configured instance of the service class (e.g.
  # Fog::Volume::OpenStack) is then made available in @service.
  def setup_vcr_and_service(options)
    # read arguments
    expect(@vcr_directory = options[:vcr_directory]).to be_a(String)
    expect(@service_class = options[:service_class]).to be_a(Class)

    # determine mode of operation
    use_recorded = !ENV.has_key?('OS_AUTH_URL')
    if use_recorded
      # when using the cassettes, there is no need to sleep in wait_for()
      Fog.interval = 0
      # use an auth URL that matches our VCR recordings (IdentityV2 for most
      # services, but IdentityV3 test obviously needs IdentityV3 auth URL)
      if [Fog::Identity::OpenStack::V3,
          Fog::Volume::OpenStack,
          Fog::Volume::OpenStack::V1,
          Fog::Volume::OpenStack::V2,
          Fog::Image::OpenStack,
          Fog::Image::OpenStack::V1,
          Fog::Network::OpenStack].include? @service_class
        @os_auth_url = ENV['OS_AUTH_URL']||'http://devstack.openstack.stack:5000/v3'
      else
        @os_auth_url = 'http://devstack.openstack.stack:5000/v2.0'
      end
    else
      # when an auth URL is given, we talk to a real OpenStack
      @os_auth_url = ENV['OS_AUTH_URL']
    end

    # setup VCR
    VCR.configure do |config|
      config.allow_http_connections_when_no_cassette = true
      config.hook_into :webmock

      if use_recorded
        config.cassette_library_dir = @vcr_directory
        config.default_cassette_options = { :record => :none }
        config.default_cassette_options.merge! :match_requests_on => [:method, :uri, :body] unless RUBY_VERSION =~ /1.8/ # Ruby 1.8.7 encodes JSON differently, which screws up request matching
      else
        config.cassette_library_dir = "spec/debug"
        config.default_cassette_options = { :record => :all }
      end
    end

    # allow us to ignore dev certificates on servers
    Excon.defaults[:ssl_verify_peer] = false if ENV['SSL_VERIFY_PEER'] == 'false'

    # setup the service object
    VCR.use_cassette('common_setup') do
      Fog::OpenStack.clear_token_cache

      if @service_class == Fog::Identity::OpenStack::V3 || @os_auth_url.end_with?('/v3')
        options = {
          :openstack_auth_url     => "#{@os_auth_url}/auth/tokens",
          :openstack_region       => ENV['OS_REGION_NAME'] || options[:region_name]     || 'RegionOne',
          :openstack_api_key      => ENV['OS_PASSWORD']    || options[:password]        || 'password',
          :openstack_username     => ENV['OS_USERNAME']    || options[:username]        || 'admin',
          :openstack_domain_name  => ENV['OS_USER_DOMAIN_NAME']|| options[:domain_name] || 'Default',
          :openstack_project_name => ENV['OS_PROJECT_NAME']|| options[:project_name]    || 'admin'
        }
        options[:openstack_service_type] = [ENV['OS_AUTH_SERVICE']] if ENV['OS_AUTH_SERVICE']
      else
        options = {
          :openstack_auth_url       => "#{@os_auth_url}/tokens",
          :openstack_region         => ENV['OS_REGION_NAME']  || options[:region_name]  || 'RegionOne',
          :openstack_api_key        => ENV['OS_PASSWORD']     || options[:password]     || 'devstack',
          :openstack_username       => ENV['OS_USERNAME']     || options[:username]     || 'admin',
          :openstack_tenant         => ENV['OS_PROJECT_NAME'] || options[:project_name] || 'admin'
          # FIXME: Identity V3 not properly supported by other services yet
          # :openstack_user_domain    => ENV['OS_USER_DOMAIN_NAME']    || 'Default',
          # :openstack_project_domain => ENV['OS_PROJECT_DOMAIN_NAME'] || 'Default',
        }
      end
      @service = @service_class.new(options)

    end
  end

end
