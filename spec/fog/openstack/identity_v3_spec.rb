require 'fog/openstack/identity'
require 'fog/openstack/identity_v3'
require 'rspec/core'
require 'rspec/expectations'
require 'vcr'

RSpec.describe Fog::Identity::OpenStack::V3 do

  before :all do |example|
    @os_auth_url = ENV['OS_AUTH_URL']

    # if OS_AUTH_URL is set but FOG_MOCK is not, don't record anything and just pass through the requests
    VCR.configure do |c|
      c.ignore_request do |request|
        ENV['FOG_MOCK']!='true' && !ENV['OS_AUTH_URL'].nil?
      end
    end if @os_auth_url

    # Fail-safe URL which matches the VCR recordings
    @os_auth_url ||= 'http://devstack.openstack.stack:5000/v3'

    VCR.configure do |config|
      config.allow_http_connections_when_no_cassette = true
      config.hook_into :webmock
      config.cassette_library_dir = "spec/fog/openstack/identity_v3"
      config.default_cassette_options = {:record => :none}
      config.default_cassette_options.merge! :match_requests_on => [:method, :uri, :body] unless RUBY_VERSION =~ /1.8/ # Ruby 1.8.7 encodes JSON differently, which screws up request matching
    end

    if ENV['DEBUG']
      VCR.configure do |config|
        config.ignore_request do |request|
          false && !ENV['OS_AUTH_URL'].nil?
        end
        config.cassette_library_dir = "spec/debug"
        config.default_cassette_options.merge! :record => :all
      end
    end

    # Allow us to ignore dev certificates on servers
    Excon.defaults[:ssl_verify_peer] = false if ENV['SSL_VERIFY_PEER'] == 'false'

    VCR.use_cassette('idv3') do
      @id_v3 = Fog::Identity::OpenStack::V3.new(
          :openstack_project_name => ENV['OS_PROJECT_NAME'] || 'admin',
          :openstack_domain_name => ENV['OS_USER_DOMAIN_NAME'] || 'Default',
          :openstack_api_key => ENV['OS_PASSWORD'] || 'password',
          :openstack_username => ENV['OS_USERNAME'] || 'admin',
          :openstack_region => ENV['OS_REGION_NAME'] || 'RegionOne',
          :openstack_auth_url => "#{@os_auth_url}/auth/tokens") unless @id_v3
    end
  end

  it 'authenticates with password, userid and domain_id' do
    VCR.use_cassette('authv3_a') do
      Fog::Identity::OpenStack::V3.new(
          :openstack_domain_id => ENV['OS_USER_DOMAIN_ID'] || 'default',
          :openstack_api_key => ENV['OS_PASSWORD'] || 'password',
          :openstack_userid => ENV['OS_USER_ID'] || 'aa9f25defa6d4cafb48466df83106065',
          :openstack_region => ENV['OS_REGION_NAME'] || 'RegionOne',
          :openstack_auth_url => "#{@os_auth_url}/auth/tokens")
    end
  end

  it 'authenticates with password, username and domain_id' do
    VCR.use_cassette('authv3_b') do
      Fog::Identity::OpenStack::V3.new(
          :openstack_domain_id => ENV['OS_USER_DOMAIN_ID'] || 'default',
          :openstack_api_key => ENV['OS_PASSWORD'] || 'password',
          :openstack_username => ENV['OS_USERNAME'] || 'admin',
          :openstack_region => ENV['OS_REGION_NAME'] || 'RegionOne',
          :openstack_auth_url => "#{@os_auth_url}/auth/tokens")
    end
  end

  it 'authenticates with password, username and domain_name' do
    VCR.use_cassette('authv3_c') do
      Fog::Identity::OpenStack::V3.new(
          :openstack_user_domain => ENV['OS_USER_DOMAIN_NAME'] || 'Default',
          :openstack_api_key => ENV['OS_PASSWORD'] || 'password',
          :openstack_username => ENV['OS_USERNAME'] || 'admin',
          :openstack_region => ENV['OS_REGION_NAME'] || 'RegionOne',
          :openstack_auth_url => "#{@os_auth_url}/auth/tokens")
    end
  end

  it 'authenticates in another region' do
    VCR.use_cassette('idv3_endpoint') do
      @endpoints_all = @id_v3.endpoints.all
    end
    endpoints_in_region = @endpoints_all.select { |endpoint| endpoint.region == (ENV['OS_REGION_OTHER']||'europe') }

    VCR.use_cassette('idv3_other_region') do
      @fog = Fog::Identity::OpenStack::V3.new({
                                                  :openstack_region => ENV['OS_REGION_OTHER']||'europe',
                                                  :openstack_auth_url => "#{@os_auth_url}/auth/tokens",
                                                  :openstack_userid => ENV['OS_USER_ID'] || 'aa9f25defa6d4cafb48466df83106065',
                                                  :openstack_api_key => ENV['OS_PASSWORD'] || "password"
                                              })
      expect(@fog).to_not be_nil
    end unless endpoints_in_region.empty?
  end

  it 'get an unscoped token, then reauthenticate with it' do
    VCR.use_cassette('authv3_unscoped_reauth') do

      @id_v3 = Fog::Identity::OpenStack::V3.new(
          :openstack_api_key => ENV['OS_PASSWORD'] || 'password',
          :openstack_userid => ENV['OS_USER_ID'] || 'aa9f25defa6d4cafb48466df83106065',
          :openstack_region => ENV['OS_REGION_NAME'] || 'RegionOne',
          :openstack_auth_url => "#{@os_auth_url}/auth/tokens")

      auth_params = {:provider => "openstack",
                     :openstack_auth_token => @id_v3.credentials[:openstack_auth_token],
                     :openstack_auth_url => "#{@os_auth_url}/auth/tokens",
                     :openstack_region => ENV['OS_REGION_NAME'] || 'RegionOne'}
      @fog2 = Fog::Identity::OpenStack::V3.new(auth_params)

      expect(@fog2).to_not be_nil
      token = @fog2.credentials[:openstack_auth_token]
      expect(token).to_not be_nil

    end
  end

  it 'authenticates with project scope' do
    VCR.use_cassette('authv3_project') do
      Fog::Identity::OpenStack::V3.new(
          :openstack_project_name => ENV['OS_PROJECT_NAME'] || 'admin',
          :openstack_domain_name => ENV['OS_USER_DOMAIN_NAME'] || 'Default',
          :openstack_api_key => ENV['OS_PASSWORD'] || 'password',
          :openstack_username => ENV['OS_USERNAME'] || 'admin',
          :openstack_region => ENV['OS_REGION_NAME'] || 'RegionOne',
          :openstack_auth_url => "#{@os_auth_url}/auth/tokens")
    end
  end

  it 'get an unscoped token, then use it to get a scoped token' do
    VCR.use_cassette('authv3_unscoped') do

      id_v3 = Fog::Identity::OpenStack::V3.new(
          :openstack_api_key => ENV['OS_PASSWORD'] || 'password',
          :openstack_userid => ENV['OS_USER_ID']||'aa9f25defa6d4cafb48466df83106065',
          :openstack_region => ENV['OS_REGION_NAME'] || 'RegionOne',
          :openstack_auth_url => "#{@os_auth_url}/auth/tokens")

      # Exchange it for a project-scoped token
      auth = Fog::Identity::OpenStack::V3.new(
          :openstack_project_name => ENV['OS_PROJECT_NAME'] || 'admin',
          :openstack_domain_name => ENV['OS_USER_DOMAIN_NAME'] || 'Default',
          :openstack_tenant => ENV['OS_USERNAME'] || 'admin',
          :openstack_auth_token => id_v3.credentials[:openstack_auth_token],
          :openstack_region => ENV['OS_REGION_NAME'] || 'RegionOne',
          :openstack_auth_url => "#{@os_auth_url}/auth/tokens")

      token = auth.credentials[:openstack_auth_token]

      # We can use the unscoped token to validate the scoped token
      validated_token = id_v3.tokens.validate(token)
      expect(validated_token).to_not be_nil

      id_v3.tokens.check(token)
      expect { id_v3.tokens.check('random-token') }.to raise_error(Fog::Identity::OpenStack::NotFound)
    end
  end

  it "find specific user, lists users" do
    VCR.use_cassette('idv3_users') do

      expect { nonexistent_user = @id_v3.users.find_by_id 'u-random-blah' }.to raise_error(Fog::Identity::OpenStack::NotFound)

      admin_user = @id_v3.users.find_by_name ENV['OS_USERNAME'] || 'admin'
      expect(admin_user.length).to be 1

      users = @id_v3.users
      expect(users).to_not be_nil
      expect(users.length).to_not be 0

      users_all = @id_v3.users.all
      expect(users_all).to_not be_nil
      expect(users_all.length).to_not be 0

      admin_by_id = @id_v3.users.find_by_id admin_user.first.id
      expect(admin_by_id).to_not be_nil

      expect(@id_v3.users.find_by_name('pimpernel').length).to be 0
    end
  end

  it 'CRUD users' do
    VCR.use_cassette('idv3_user_crud') do

      # Make sure there are no existing users called foobar or baz
      ['foobar', 'baz'].each do |username|
        user = @id_v3.users.find_by_name(username).first
        user.update(:enabled => false) if user
        user.destroy if user
      end
      expect(@id_v3.users.find_by_name('foobar').length).to be 0
      expect(@id_v3.users.find_by_name('baz').length).to be 0

      # Create a user called foobar
      foobar_user = @id_v3.users.create(:name => 'foobar',
                                        :email => 'foobar@example.com',
                                        :password => 's3cret!')
      foobar_id = foobar_user.id
      expect(@id_v3.users.find_by_name('foobar').length).to be 1

      # Rename it to baz and disable it (required so we can delete it)
      foobar_user.update(:name => 'baz', :enabled => false)
      expect(foobar_user.name).to eq 'baz'

      # Read the user freshly and check the name & enabled state
      expect(@id_v3.users.find_by_name('baz').length).to be 1
      baz_user = @id_v3.users.find_by_id foobar_id
      expect(baz_user).to_not be_nil
      expect(baz_user.name).to eq 'baz'
      expect(baz_user.email).to eq 'foobar@example.com'
      expect(baz_user.enabled).to be false

      # Try to create the user again
      expect { @id_v3.users.create(:name => 'baz',
                                   :email => 'foobar@example.com',
                                   :password => 's3cret!') }.to raise_error(Excon::Errors::Conflict)

      # Delete the user
      baz_user.destroy
      # Check that the deletion worked
      expect { @id_v3.users.find_by_id foobar_id }.to raise_error(Fog::Identity::OpenStack::NotFound)
      expect(@id_v3.users.all.select { |user| ['foobar', 'baz'].include? user.name }.length).to be 0
      expect(@id_v3.users.find_by_name('foobar').length).to be 0
      expect(@id_v3.users.find_by_name('baz').length).to be 0
    end
  end

  it "CRUD & manipulate groups" do
    VCR.use_cassette('idv3_group_crud_mutation') do

      # Make sure there are no existing groups called foobar or baz
      @id_v3.groups.all.select { |group| ['foobar', 'baz'].include? group.name }.each do |group|
        group.destroy
      end
      expect(@id_v3.groups.all.select { |group| ['foobar', 'baz'].include? group.name }.length).to be 0

      # Create a group called foobar
      foobar_group = @id_v3.groups.create(:name => 'foobar', :description => "Group of Foobar users")
      foobar_id = foobar_group.id
      expect(@id_v3.groups.all.select { |group| group.name == 'foobar' }.length).to be 1

      # Rename it to baz
      foobar_group.update(:name => 'baz', :description => "Group of Baz users")
      expect(foobar_group.name).to eq 'baz'

      # Read the group freshly and check the name
      expect(@id_v3.groups.all.select { |group| group.name == 'baz' }.length).to be 1
      baz_group = @id_v3.groups.find_by_id foobar_id
      expect(baz_group).to_not be_nil
      expect(baz_group.name).to eq 'baz'

      # Add users to the group
      #foobar_user1 = @id_v3.users.find_by_name('foobar1').first
      #foobar_user1.destroy if foobar_user1
      foobar_user1 = @id_v3.users.create(:name => 'foobar1',
                                         :email => 'foobar1@example.com',
                                         :password => 's3cret!1')
      #foobar_user2 = @id_v3.users.find_by_name('foobar2').first
      #foobar_user2.destroy if foobar_user2
      foobar_user2 = @id_v3.users.create(:name => 'foobar2',
                                         :email => 'foobar2@example.com',
                                         :password => 's3cret!2')

      expect(foobar_user1.groups.length).to be 0
      expect(baz_group.users.length).to be 0

      baz_group.add_user(foobar_user1.id)

      # Check that a user is in the group
      expect(foobar_user1.groups.length).to be 1
      expect(baz_group.contains_user? foobar_user1.id).to be true

      baz_group.add_user(foobar_user2.id)

      # List users in the group
      expect(baz_group.users.length).to be 2


      # Remove a user from the group
      baz_group.remove_user(foobar_user1.id)
      expect(baz_group.contains_user? foobar_user1.id).to be false
      expect(baz_group.users.length).to be 1

      # Delete the users and make sure they are no longer in the group
      foobar_user1.destroy
      foobar_user2.destroy
      expect(baz_group.contains_user? foobar_user2.id).to be false
      expect(baz_group.users.length).to be 0

      # Delete the group
      baz_group.destroy
      expect { @id_v3.groups.find_by_id foobar_id }.to raise_error(Fog::Identity::OpenStack::NotFound)
      expect(@id_v3.groups.all.select { |group| ['foobar', 'baz'].include? group.name }.length).to be 0
    end
  end

  it "gets a token, checks it and then revokes it" do
    VCR.use_cassette('idv3_token') do
      auth = {:auth => {:identity => {:methods => %w{password},
                                      :password => {:user => {:id => ENV['OS_USER_ID']||'aa9f25defa6d4cafb48466df83106065',
                                                              :password => ENV['OS_PASSWORD']||'password'}}},
                        :scope => {:project => {:domain => {:name => ENV['OS_USER_DOMAIN_NAME']||'Default'},
                                                :name => ENV['OS_PROJECT_NAME']||'admin'}}}}

      token = @id_v3.tokens.authenticate(auth)
      expect(token).to_not be_nil

      validated_token = @id_v3.tokens.validate token.value
      expect(validated_token).to_not be_nil

      @id_v3.tokens.check(token.value)
      @id_v3.tokens.revoke(token.value)

      expect { @id_v3.tokens.check(token.value) }.to raise_error(Fog::Identity::OpenStack::NotFound)
    end
  end

  it 'authenticates with a token' do
    VCR.use_cassette('authv3_token') do
      # Setup - get a non-admin token to check by using username/password authentication to start with
      auth_url = "#{@os_auth_url}/auth/tokens"

      begin

        foobar_user = @id_v3.users.create(:name => 'foobar_385',
                                          :email => 'foobar_demo@example.com',
                                          :domain_id => ENV['OS_USER_DOMAIN_ID'] || 'default',
                                          :password => 's3cret!')

        foobar_role = @id_v3.roles.create(:name => 'foobar_role390')
        foobar_user.grant_role(foobar_role.id)

        nonadmin_v3 = Fog::Identity::OpenStack::V3.new(
            :openstack_domain_id => foobar_user.domain_id,
            :openstack_api_key => 's3cret!',
            :openstack_username => 'foobar_385',
            :openstack_region => ENV['OS_REGION_NAME']||'europe',
            :openstack_auth_url => auth_url)

        # Test - check the token validity by using it to create a new Fog::Identity::OpenStack::V3 instance
        token_check = Fog::Identity::OpenStack::V3.new(
            :openstack_auth_token => nonadmin_v3.auth_token,
            :openstack_region => ENV['OS_REGION_NAME']||'europe',
            :openstack_auth_url => auth_url)

        expect(token_check).to_not be_nil

        expect { Fog::Identity::OpenStack::V3.new(
            :openstack_auth_token => 'blahblahblah',
            :openstack_region => ENV['OS_REGION_NAME']||'europe',
            :openstack_auth_url => auth_url) }.to raise_error(Excon::Errors::NotFound)
      ensure
        # Clean up
        foobar_user = @id_v3.users.find_by_name('foobar_385').first unless foobar_user
        foobar_user.destroy if foobar_user
        foobar_role = @id_v3.roles.all.select { |role| role.name == 'foobar_role390' }.first unless foobar_role
        foobar_role.destroy if foobar_role
      end

    end
  end

  it "lists domains" do
    VCR.use_cassette('idv3_domain') do

      domains = @id_v3.domains
      expect(domains).to_not be_nil
      expect(domains.length).to_not be 0

      domains_all = @id_v3.domains.all
      expect(domains_all).to_not be_nil
      expect(domains_all.length).to_not be 0

      default_domain = @id_v3.domains.find_by_id ENV['OS_USER_DOMAIN_ID']||'default'
      expect(default_domain).to_not be_nil

      expect { @id_v3.domains.find_by_id 'atlantis' }.to raise_error(Fog::Identity::OpenStack::NotFound)
    end
  end

  it "CRUD domains" do
    VCR.use_cassette('idv3_domain_crud') do

      begin
        # Create a domain called foobar
        foobar_domain = @id_v3.domains.create(:name => 'foobar')
        foobar_id = foobar_domain.id
        expect(@id_v3.domains.all(:name => 'foobar').length).to be 1

        # Rename it to baz and disable it (required so we can delete it)
        foobar_domain.update(:name => 'baz', :enabled => false)
        expect(foobar_domain.name).to eq 'baz'

        # Read the domain freshly and check the name & enabled state
        expect(@id_v3.domains.all(:name => 'baz').length).to be 1
        baz_domain = @id_v3.domains.find_by_id foobar_id
        expect(baz_domain).to_not be_nil
        expect(baz_domain.name).to eq 'baz'
        expect(baz_domain.enabled).to be false
      ensure
        # Delete the domains
        begin
          baz_domain.update(:enabled => false) if baz_domain
          baz_domain.destroy if baz_domain
          foobar_domain.update(:enabled => false) if foobar_domain
          foobar_domain.destroy if foobar_domain
        rescue
        end
        # Check that the deletion worked
        expect { @id_v3.domains.find_by_id foobar_id }.to raise_error(Fog::Identity::OpenStack::NotFound) if foobar_id
        ['foobar', 'baz'].each do |domain_name|
          expect(@id_v3.domains.all(:name => domain_name).length).to be 0
        end
      end
    end
  end

  it "Manipulates roles on domains" do
    # Note that the domain is implicit in the user operations here

    VCR.use_cassette('idv3_domain_roles_mutation') do
      begin
        foobar_user = @id_v3.users.create(:name => 'foobar_role_user',
                                          :email => 'foobar@example.com',
                                          :password => 's3cret!')

        # User has no roles initially
        expect(foobar_user.roles.length).to be 0

        # Create a role and add it to the user in the user's domain
        foobar_role = @id_v3.roles.create(:name => 'foobar_role')
        foobar_user.grant_role(foobar_role.id)
        expect(foobar_user.roles.length).to be 1
        assignments = @id_v3.role_assignments.all(:user_id => foobar_user.id)
        expect(assignments.length).to be 1
        expect(assignments.first.role['id']).to eq foobar_role.id
        expect(assignments.first.user['id']).to eq foobar_user.id
        expect(assignments.first.scope['domain']['id']).to eq foobar_user.domain_id
        expect(assignments.first.links['assignment'].end_with? "/v3/domains/#{foobar_user.domain_id}/users/#{foobar_user.id}/roles/#{foobar_role.id}").to be true

        # Quick test of @id_v3.role_assignments.all while we're at it
        all_assignments = @id_v3.role_assignments.all
        expect(all_assignments.length).to be >= 1

        # Check that the user has the role
        expect(foobar_user.check_role(foobar_role.id)).to be true

        # Revoke the role from the user
        foobar_user.revoke_role(foobar_role.id)
        expect(foobar_user.check_role(foobar_role.id)).to be false
      ensure
        foobar_user = @id_v3.users.find_by_name('u-foobar_role_user').first unless foobar_user
        foobar_user.destroy if foobar_user
        foobar_role = @id_v3.roles.all.select { |role| role.name == 'foobar_role' }.first unless foobar_role
        foobar_role.destroy if foobar_role
      end

    end
  end

  it "Manipulates roles on domain groups" do
    VCR.use_cassette('idv3_domain_group_roles_mutation') do

      begin
        # Create a domain called foobar
        foobar_domain = @id_v3.domains.create(:name => 'd-foobar')

        # Create a group in this domain
        foobar_group = @id_v3.groups.create(:name => 'g-foobar',
                                            :description => "Group of Foobar users",
                                            :domain_id => foobar_domain.id)

        # Create a user in the domain
        foobar_user = @id_v3.users.create(:name => 'u-foobar_foobar',
                                          :email => 'foobar@example.com',
                                          :password => 's3cret!',
                                          :domain_id => foobar_domain.id)

        # User has no roles initially
        expect(foobar_user.roles.length).to be 0

        # Create a role and add it to the domain group
        foobar_role = @id_v3.roles.all.select { |role| role.name == 'foobar_role' }.first
        foobar_role.destroy if foobar_role
        foobar_role = @id_v3.roles.create(:name => 'foobar_role')

        foobar_group.grant_role foobar_role.id
        expect(foobar_group.roles.length).to be 1

        # Add user to the group and check that it inherits the role
        expect(foobar_user.check_role foobar_role.id).to be false
        expect(@id_v3.role_assignments.all(:user_id => foobar_user.id, :effective => true).length).to be 0
        foobar_group.add_user foobar_user.id
        expect(foobar_user.check_role foobar_role.id).to be false # Still false in absolute assignment terms
        assignments = @id_v3.role_assignments.all(:user_id => foobar_user.id, :effective => true)
        expect(assignments.length).to be 1
        expect(assignments.first.role['id']).to eq foobar_role.id
        expect(assignments.first.user['id']).to eq foobar_user.id
        expect(assignments.first.scope['domain']['id']).to eq foobar_user.domain_id
        expect(assignments.first.links['assignment'].end_with? "/v3/domains/#{foobar_domain.id}/groups/#{foobar_group.id}/roles/#{foobar_role.id}").to be true
        expect(assignments.first.links['membership'].end_with? "/v3/groups/#{foobar_group.id}/users/#{foobar_user.id}").to be true

        group_assignments = @id_v3.role_assignments.all(:group_id => foobar_group.id)
        expect(group_assignments.length).to be 1
        expect(group_assignments.first.role['id']).to eq foobar_role.id
        expect(group_assignments.first.group['id']).to eq foobar_group.id
        expect(group_assignments.first.scope['domain']['id']).to eq foobar_user.domain_id
        expect(group_assignments.first.links['assignment'].end_with? "/v3/domains/#{foobar_domain.id}/groups/#{foobar_group.id}/roles/#{foobar_role.id}").to be true

        # Revoke the role from the group and check the user no longer has it
        foobar_group.revoke_role foobar_role.id
        expect(@id_v3.role_assignments.all(:user_id => foobar_user.id, :effective => true).length).to be 0
      ensure
        # Clean up
        foobar_user = @id_v3.users.find_by_name('u-foobar_foobar').first unless foobar_user
        foobar_user.destroy if foobar_user
        foobar_group = @id_v3.groups.all.select { |group| group.name == 'g-foobar' }.first unless foobar_group
        foobar_group.destroy if foobar_group
        foobar_role = @id_v3.roles.all.select { |role| role.name == 'foobar_role' }.first unless foobar_role
        foobar_role.destroy if foobar_role
        foobar_domain = @id_v3.domains.all.select { |domain| domain.name == 'd-foobar' }.first unless foobar_domain
        foobar_domain.update(:enabled => false) if foobar_domain
        foobar_domain.destroy if foobar_domain
      end
    end
  end

  it "lists roles" do
    VCR.use_cassette('idv3_role') do

      roles = @id_v3.roles
      expect(roles).to_not be_nil
      expect(roles.length).to_not be 0

      roles_all = @id_v3.roles.all
      expect(roles_all).to_not be_nil
      expect(roles_all.length).to_not be 0

      role_by_id = @id_v3.roles.find_by_id roles_all.first.id
      expect(role_by_id).to_not be_nil

      expect { @id_v3.roles.find_by_id 'atlantis' }.to raise_error(Fog::Identity::OpenStack::NotFound)
    end
  end

  it "CRUD roles" do
    VCR.use_cassette('idv3_role_crud') do

      begin
        # Create a role called foobar
        foobar_role = @id_v3.roles.create(:name => 'foobar23')
        foobar_id = foobar_role.id
        expect(@id_v3.roles.all(:name => 'foobar23').length).to be 1

        # Rename it to baz
        foobar_role.update(:name => 'baz23')
        expect(foobar_role.name).to eq 'baz23'

        # Read the role freshly and check the name & enabled state
        expect(@id_v3.roles.all(:name => 'baz23').length).to be 1
        baz_role = @id_v3.roles.find_by_id foobar_id
        expect(baz_role).to_not be_nil
        expect(baz_role.name).to eq 'baz23'
      ensure
        # Delete the role
        baz_role.destroy if baz_role
        # Check that the deletion worked
        expect { @id_v3.roles.find_by_id foobar_id }.to raise_error(Fog::Identity::OpenStack::NotFound) if foobar_id
        ['foobar23', 'baz23'].each do |role_name|
          expect(@id_v3.roles.all(:name => role_name).length).to be 0
        end
      end
    end
  end

  it "lists projects" do
    VCR.use_cassette('idv3_project') do

      projects = @id_v3.projects
      expect(projects).to_not be_nil
      expect(projects.length).to_not be 0

      projects_all = @id_v3.projects.all
      expect(projects_all).to_not be_nil
      expect(projects_all.length).to_not be 0
      project_byid = @id_v3.projects.find_by_id projects_all.first.id
      expect(project_byid).to_not be_nil

      expect { @id_v3.projects.find_by_id 'atlantis' }.to raise_error(Fog::Identity::OpenStack::NotFound)
    end
  end

  it "CRUD projects" do
    VCR.use_cassette('idv3_project_crud') do

      default_domain = @id_v3.domains.find_by_id ENV['OS_USER_DOMAIN_ID']||'default'

      begin
        # Create a project called foobar - should not work without domain id?
        foobar_project = @id_v3.projects.create(:name => 'p-foobar46')
        foobar_id = foobar_project.id
        expect(@id_v3.projects.all(:name => 'p-foobar46').length).to be 1
        expect(foobar_project.domain_id).to eq default_domain.id

        # Rename it to baz and disable it (required so we can delete it)
        foobar_project.update(:name => 'p-baz46', :enabled => false)
        expect(foobar_project.name).to eq 'p-baz46'

        # Read the project freshly and check the name & enabled state
        expect(@id_v3.projects.all(:name => 'p-baz46').length).to be 1
        baz_project = @id_v3.projects.find_by_id foobar_id
        expect(baz_project).to_not be_nil
        expect(baz_project.name).to eq 'p-baz46'
        expect(baz_project.enabled).to be false
      ensure
        # Delete the project
        baz_project.destroy

        # Check that the deletion worked
        expect { @id_v3.projects.find_by_id foobar_id }.to raise_error(Fog::Identity::OpenStack::NotFound)
        ['p-foobar46', 'p-baz46'].each do |project_name|
          expect(@id_v3.projects.all(:name => project_name).length).to be 0
        end
      end
    end
  end

  it "Manipulates projects - add/remove users/groups via role assignment/revocation" do
    VCR.use_cassette('idv3_project_group_user_roles_mutation') do

      # Make sure there is no existing project called foobar
      @id_v3.projects.all(:name => 'p-foobar69').each do |project|
        project.update(:enabled => false)
        project.destroy
      end
      expect(@id_v3.projects.all(:name => 'p-foobar69').length).to be 0

      begin
        # Create a project called foobar
        foobar_project = @id_v3.projects.create(:name => 'p-foobar69')
        # Create a role called baz
        @id_v3.roles.all(:name => 'baz').each do |role|
          role.update(:enabled => false)
          role.destroy
        end
        baz_role = @id_v3.roles.create(:name => 'baz69')

        # Create a user
        foobar_user = @id_v3.users.create(:name => 'u-foobar69',
                                          :email => 'foobar@example.com',
                                          :password => 's3cret!')

        # Create a group and add the user to it
        foobar_group = @id_v3.groups.create(:name => 'g-foobar69',
                                            :description => "Group of Foobar users")
        foobar_group.add_user foobar_user.id

        # User has no projects initially
        expect(foobar_user.projects.length).to be 0
        expect(@id_v3.role_assignments.all(:user_id => foobar_user.id,
                                           :project_id => foobar_project.id,
                                           :effective => true).length).to be 0
        expect(foobar_project.user_roles(foobar_user.id).length).to be 0

        # Grant role to the user in the new project - this assigns the project to the user
        foobar_project.grant_role_to_user(baz_role.id, foobar_user.id)
        expect(foobar_user.projects.length).to be 1
        expect(foobar_project.check_user_role(foobar_user.id, baz_role.id)).to be true
        expect(foobar_project.user_roles(foobar_user.id).length).to be 1

        # Revoke role from the user in the new project - this removes the user from the project
        foobar_project.revoke_role_from_user(baz_role.id, foobar_user.id)
        expect(foobar_user.projects.length).to be 0
        expect(foobar_project.check_user_role(foobar_user.id, baz_role.id)).to be false

        # Group initially has no roles in project
        expect(foobar_project.group_roles(foobar_group.id).length).to be 0

        expect(@id_v3.role_assignments.all(:user_id => foobar_user.id,
                                           :project_id => foobar_project.id,
                                           :effective => true).length).to be 0

        # Grant role to the group in the new project - this assigns the project to the group
        foobar_project.grant_role_to_group(baz_role.id, foobar_group.id)
        expect(foobar_project.check_group_role(foobar_group.id, baz_role.id)).to be true
        expect(foobar_project.group_roles(foobar_group.id).length).to be 1

        # Now we check that a user has the role in that project
        assignments = @id_v3.role_assignments.all(:user_id => foobar_user.id,
                                                  :project_id => foobar_project.id,
                                                  :effective => true)
        expect(assignments.length).to be 1
        expect(assignments.first.role['id']).to eq baz_role.id
        expect(assignments.first.user['id']).to eq foobar_user.id
        expect(assignments.first.scope['project']['id']).to eq foobar_project.id
        expect(assignments.first.links['assignment'].end_with? "/v3/projects/#{foobar_project.id}/groups/#{foobar_group.id}/roles/#{baz_role.id}").to be true
        expect(assignments.first.links['membership'].end_with? "/v3/groups/#{foobar_group.id}/users/#{foobar_user.id}").to be true

        # and we check that the user is in the project because of group membership
        expect(foobar_user.projects.length).to be 1

        # Revoke role from the group in the new project - this removes the group from the project
        foobar_project.revoke_role_from_group(baz_role.id, foobar_group.id)
        expect(foobar_user.projects.length).to be 0
        expect(foobar_project.check_group_role(foobar_group.id, baz_role.id)).to be false

      ensure
        # Clean up
        foobar_user.destroy if foobar_user
        foobar_group.destroy if foobar_group
        baz_role.destroy if baz_role
        foobar_project.update(:enabled => false) if foobar_project
        foobar_project.destroy if foobar_project
      end
    end
  end

  it "lists services" do
    VCR.use_cassette('idv3_service') do

      services = @id_v3.services
      expect(services).to_not be_nil
      expect(services.length).to_not be 0

      services_all = @id_v3.services.all
      expect(services_all).to_not be_nil
      expect(services_all.length).to_not be 0

      some_service = @id_v3.services.find_by_id services_all.first.id
      expect(some_service).to_not be_nil

      expect { @id_v3.services.find_by_id 'atlantis' }.to raise_error(Fog::Identity::OpenStack::NotFound)
    end
  end

  it "CRUD services" do
    VCR.use_cassette('idv3_services_crud') do

      all_services = @id_v3.services.all

      begin
        # Create a service called foobar
        foobar_service = @id_v3.services.create(:type => 'volume', :name => 'foobar')
        foobar_id = foobar_service.id
        expect(@id_v3.services.all(:type => 'volume').select { |service| service.name == 'foobar' }.length).to be 1

        # Rename it to baz
        foobar_service.update(:name => 'baz')
        expect(foobar_service.name).to eq 'baz'

        # Read the service freshly and check the name
        expect(@id_v3.services.all.select { |service| service.name == 'baz' }.length).to be 1
        baz_service = @id_v3.services.find_by_id foobar_id
        expect(baz_service).to_not be_nil
        expect(baz_service.name).to eq 'baz'
        expect(baz_service.type).to eq 'volume'
      ensure
        # Delete the service
        baz_service.destroy if baz_service

        # Check that the deletion worked
        expect { @id_v3.services.find_by_id foobar_id }.to raise_error(Fog::Identity::OpenStack::NotFound) if foobar_id
        expect(@id_v3.services.all.select { |service| ['foobar', 'baz'].include? service.name }.length).to be 0
      end
    end
  end

  it "lists endpoints" do
    VCR.use_cassette('idv3_endpoint') do

      endpoints = @id_v3.endpoints
      expect(endpoints).to_not be_nil
      expect(endpoints.length).to_not be 0

      endpoints_all = @id_v3.endpoints.all
      expect(endpoints_all).to_not be_nil
      expect(endpoints_all.length).to_not be 0

      some_endpoint = @id_v3.endpoints.find_by_id endpoints_all.first.id
      expect(some_endpoint).to_not be_nil

      expect { @id_v3.endpoints.find_by_id 'atlantis' }.to raise_error(Fog::Identity::OpenStack::NotFound)
    end
  end

  it "CRUD endpoints" do
    VCR.use_cassette('idv3_endpoints_crud') do

      service = @id_v3.services.all.first
      all_endpoints = @id_v3.endpoints.all

      begin
        # Create a endpoint called foobar
        foobar_endpoint = @id_v3.endpoints.create(:service_id => service.id,
                                                  :interface => 'internal',
                                                  :name => 'foobar',
                                                  :url => 'http://example.com/foobar',
                                                  :enabled => false)
        foobar_id = foobar_endpoint.id
        expect(@id_v3.endpoints.all(:interface => 'internal').select { |endpoint| endpoint.name == 'foobar' }.length).to be 1

        # Rename it to baz
        foobar_endpoint.update(:name => 'baz', :url => 'http://example.com/baz')
        expect(foobar_endpoint.name).to eq 'baz'
        expect(foobar_endpoint.url).to eq 'http://example.com/baz'

        # Read the endpoint freshly and check the name
        expect(@id_v3.endpoints.all(:interface => 'internal').select { |endpoint| endpoint.name == 'baz' }.length).to be 1
        baz_endpoint = @id_v3.endpoints.find_by_id foobar_id
        expect(baz_endpoint).to_not be_nil
        expect(baz_endpoint.name).to eq 'baz'
        expect(baz_endpoint.url).to eq 'http://example.com/baz'
        expect(baz_endpoint.interface).to eq 'internal'
      ensure
        # Delete the endpoint
        baz_endpoint.destroy

        # Check that the deletion worked
        expect { @id_v3.endpoints.find_by_id foobar_id }.to raise_error(Fog::Identity::OpenStack::NotFound)
        expect(@id_v3.endpoints.all.select { |endpoint| ['foobar', 'baz'].include? endpoint.name }.length).to be 0
      end
    end
  end

  it "lists OS credentials" do
    VCR.use_cassette('idv3_credential') do
      credentials = @id_v3.os_credentials
      expect(credentials).to_not be_nil

      credentials_all = @id_v3.os_credentials.all
      expect(credentials_all).to_not be_nil

      expect { @id_v3.os_credentials.find_by_id 'atlantis' }.to raise_error(Fog::Identity::OpenStack::NotFound)
    end
  end

  it "CRUD OS credentials" do
    VCR.use_cassette('idv3_credential_crud') do

      begin
        # Create a user
        foobar_user = @id_v3.users.create(:name => 'u-foobar_cred',
                                          :email => 'foobar@example.com',
                                          :password => 's3cret!')
        project = @id_v3.projects.all.first

        access_key = '9c4e774a-f644-498f-90c4-970b3f817fc5'
        secret_key = '7e084117-b13d-4656-9eca-85376b690897'

        # OpenStack Keystone requires the blob to be a JSON string - i.e. not JSON, but a string containing JSON :-/
        blob_json = {:access => access_key,
                     :secret => secret_key}.to_json

        # Make sure there are no existing ec2 credentials
        @id_v3.os_credentials.all.select { |credential| credential.type == 'foo' || credential.type == 'ec2' }.each do |credential|
          credential.destroy
        end
        expect(@id_v3.os_credentials.all.select { |credential| credential.type == 'ec2' }.length).to be 0

        # Create a credential
        foo_credential = @id_v3.os_credentials.create(:type => 'ec2',
                                                      :project_id => project.id,
                                                      :user_id => foobar_user.id,
                                                      :blob => blob_json)
        credential_id = foo_credential.id
        expect(@id_v3.os_credentials.all.select { |credential| credential.type == 'ec2' }.length).to be 1

        # Update secret key
        new_secret_key = '62307bcd-ca3c-47ae-a114-27a6cadb5bc9'
        new_blob_json = {:access => access_key,
                         :secret => new_secret_key}.to_json
        foo_credential.update(:blob => new_blob_json)
        expect(JSON.parse(foo_credential.blob)['secret']).to eq new_secret_key

        # Read the credential freshly and check the secret key
        expect(@id_v3.os_credentials.all.select { |credential| credential.type == 'ec2' }.length).to be 1
        updated_credential = @id_v3.os_credentials.find_by_id credential_id
        expect(updated_credential).to_not be_nil
        expect(updated_credential.type).to eq 'ec2'
        expect(JSON.parse(updated_credential.blob)['secret']).to eq new_secret_key

      ensure
        foobar_user = @id_v3.users.find_by_name('u-foobar_cred').first unless foobar_user
        foobar_user.destroy if foobar_user
        # Delete the credential
        begin
          updated_credential.destroy if updated_credential
          foo_credential.destroy if foo_credential
        rescue
          false
        end

        # Check that the deletion worked
        expect { @id_v3.os_credentials.find_by_id credential_id }.to raise_error(Fog::Identity::OpenStack::NotFound) if credential_id
        expect(@id_v3.os_credentials.all.select { |credential| credential.type == 'ec2' }.length).to be 0
      end
    end
  end

  it "lists policies" do
    VCR.use_cassette('idv3_policy') do
      policies = @id_v3.policies
      expect(policies).to_not be_nil
      expect(policies.length).to be 0

      policies_all = @id_v3.policies.all
      expect(policies_all).to_not be_nil
      expect(policies_all.length).to be 0

      expect { @id_v3.policies.find_by_id 'atlantis' }.to raise_error(Fog::Identity::OpenStack::NotFound)
    end
  end

  it "CRUD policies" do
    VCR.use_cassette('idv3_policy_crud') do

      blob = {'foobar_user' => ['role:compute-user']}.to_json

      # Make sure there are no existing policies
      expect(@id_v3.policies.all.select { |policy| policy.type == 'application/json' }.length).to be 0

      # Create a policy
      foo_policy = @id_v3.policies.create(:type => 'application/json',
                                          :blob => blob)
      policy_id = foo_policy.id
      expect(@id_v3.policies.all.select { |policy| policy.type == 'application/json' }.length).to be 1

      # Update policy blob
      new_blob = {'baz_user' => ['role:compute-user']}.to_json
      foo_policy.update(:blob => new_blob)
      expect(foo_policy.blob).to eq new_blob

      # Read the policy freshly and check the secret key
      expect(@id_v3.policies.all.select { |policy| policy.type == 'application/json' }.length).to be 1
      updated_policy = @id_v3.policies.find_by_id policy_id
      expect(updated_policy).to_not be_nil
      expect(updated_policy.type).to eq 'application/json'
      expect(updated_policy.blob).to eq new_blob

      # Delete the policy
      updated_policy.destroy

      # Check that the deletion worked
      expect { @id_v3.policies.find_by_id policy_id }.to raise_error(Fog::Identity::OpenStack::NotFound)
      expect(@id_v3.policies.all.select { |policy| policy.type == 'application/json' }.length).to be 0
    end
  end

end
