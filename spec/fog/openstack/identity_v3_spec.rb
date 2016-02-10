require 'fog/openstack/identity'
require 'fog/openstack/identity_v3'

if RUBY_VERSION =~ /1.8/
  require File.expand_path('../shared_context', __FILE__)
else
  require_relative './shared_context'
end

RSpec.describe Fog::Identity::OpenStack::V3 do

  include_context 'OpenStack specs with VCR'
  before :all do
    VCR_USER_ID='a18abc2039d6493aa7239a42033cc7c9'
    VCR_USER_NAME='admin'
    VCR_PASSWORD='devstack'
    VCR_DOMAIN_ID='default'
    VCR_DOMAIN_NAME='Default'
    VCR_PROJECT_NAME='admin'
    VCR_REGION='RegionOne'

    setup_vcr_and_service(
        :vcr_directory => 'spec/fog/openstack/identity_v3',
        :service_class => Fog::Identity::OpenStack::V3,
        :username => VCR_USER_NAME,
        :password => VCR_PASSWORD,
        :project_name => VCR_PROJECT_NAME,
        :domain_name => VCR_DOMAIN_NAME,
        :region_name => VCR_REGION
    )
  end

  it 'authenticates with password, userid and domain_id' do
    VCR.use_cassette('authv3_a') do
      Fog::Identity::OpenStack::V3.new(
          :openstack_domain_id => ENV['OS_USER_DOMAIN_ID'] || VCR_DOMAIN_ID,
          :openstack_api_key => ENV['OS_PASSWORD'] || VCR_PASSWORD,
          :openstack_userid => ENV['OS_USER_ID'] || VCR_USER_ID,
          :openstack_region => ENV['OS_REGION_NAME'] || VCR_REGION,
          :openstack_auth_url => "#{@os_auth_url}/auth/tokens")
    end
  end

  it 'authenticates with password, username and domain_id' do
    VCR.use_cassette('authv3_b') do
      Fog::Identity::OpenStack::V3.new(
          :openstack_domain_id => ENV['OS_USER_DOMAIN_ID'] || VCR_DOMAIN_ID,
          :openstack_api_key => ENV['OS_PASSWORD'] || VCR_PASSWORD,
          :openstack_username => ENV['OS_USERNAME'] || VCR_USER_NAME,
          :openstack_region => ENV['OS_REGION_NAME'] || VCR_REGION,
          :openstack_auth_url => "#{@os_auth_url}/auth/tokens")
    end
  end

  it 'authenticates with password, username and domain_name' do
    VCR.use_cassette('authv3_c') do
      Fog::Identity::OpenStack::V3.new(
          :openstack_user_domain => ENV['OS_USER_DOMAIN_NAME'] || VCR_DOMAIN_NAME,
          :openstack_api_key => ENV['OS_PASSWORD'] || VCR_PASSWORD,
          :openstack_username => ENV['OS_USERNAME'] || VCR_USER_NAME,
          :openstack_region => ENV['OS_REGION_NAME'] || VCR_REGION,
          :openstack_auth_url => "#{@os_auth_url}/auth/tokens")
    end
  end

  it 'authenticates in another region' do
    VCR.use_cassette('idv3_endpoint') do
      @endpoints_all = @service.endpoints.all
    end
    endpoints_in_region = @endpoints_all.select { |endpoint| endpoint.region == (ENV['OS_REGION_OTHER']||'europe') }

    VCR.use_cassette('idv3_other_region') do
      @fog = Fog::Identity::OpenStack::V3.new({
                                                  :openstack_region => ENV['OS_REGION_OTHER']||'europe',
                                                  :openstack_auth_url => "#{@os_auth_url}/auth/tokens",
                                                  :openstack_userid => ENV['OS_USER_ID'] || VCR_USER_ID,
                                                  :openstack_api_key => ENV['OS_PASSWORD'] || VCR_PASSWORD
                                              })
      expect(@fog).to_not be_nil
    end unless endpoints_in_region.empty?
  end

  it 'get an unscoped token, then reauthenticate with it' do
    VCR.use_cassette('authv3_unscoped_reauth') do

      id_v3 = Fog::Identity::OpenStack::V3.new(
          :openstack_api_key => ENV['OS_PASSWORD'] || VCR_PASSWORD,
          :openstack_userid => ENV['OS_USER_ID'] || VCR_USER_ID,
          :openstack_region => ENV['OS_REGION_NAME'] || VCR_REGION,
          :openstack_auth_url => "#{@os_auth_url}/auth/tokens")

      auth_params = {:provider => "openstack",
                     :openstack_auth_token => id_v3.credentials[:openstack_auth_token],
                     :openstack_auth_url => "#{@os_auth_url}/auth/tokens",
                     :openstack_region => ENV['OS_REGION_NAME'] || VCR_REGION}
      @fog2 = Fog::Identity::OpenStack::V3.new(auth_params)

      expect(@fog2).to_not be_nil
      token = @fog2.credentials[:openstack_auth_token]
      expect(token).to_not be_nil

    end
  end

  it 'authenticates with project scope' do
    VCR.use_cassette('authv3_project') do
      Fog::Identity::OpenStack::V3.new(
          :openstack_project_name => ENV['OS_PROJECT_NAME'] || VCR_PROJECT_NAME,
          :openstack_domain_name => ENV['OS_USER_DOMAIN_NAME'] || VCR_DOMAIN_NAME,
          :openstack_api_key => ENV['OS_PASSWORD'] || VCR_PASSWORD,
          :openstack_username => ENV['OS_USERNAME'] || VCR_USER_NAME,
          :openstack_region => ENV['OS_REGION_NAME'] || VCR_REGION,
          :openstack_auth_url => "#{@os_auth_url}/auth/tokens")
    end
  end

  it 'get an unscoped token, then use it to get a scoped token' do
    VCR.use_cassette('authv3_unscoped') do

      id_v3 = Fog::Identity::OpenStack::V3.new(
          :openstack_api_key => ENV['OS_PASSWORD'] || VCR_PASSWORD,
          :openstack_userid => ENV['OS_USER_ID']||VCR_USER_ID,
          :openstack_region => ENV['OS_REGION_NAME'] || VCR_REGION,
          :openstack_auth_url => "#{@os_auth_url}/auth/tokens")

      # Exchange it for a project-scoped token
      auth = Fog::Identity::OpenStack::V3.new(
          :openstack_project_name => ENV['OS_PROJECT_NAME'] || VCR_PROJECT_NAME,
          :openstack_domain_name => ENV['OS_USER_DOMAIN_NAME'] || VCR_DOMAIN_NAME,
          :openstack_tenant => ENV['OS_USERNAME'] || VCR_USER_NAME,
          :openstack_auth_token => id_v3.credentials[:openstack_auth_token],
          :openstack_region => ENV['OS_REGION_NAME'] || VCR_REGION,
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

      expect { nonexistent_user = @service.users.find_by_id 'u-random-blah' }.to raise_error(Fog::Identity::OpenStack::NotFound)

      admin_user = @service.users.find_by_name ENV['OS_USERNAME'] || VCR_USER_NAME
      expect(admin_user.length).to be 1

      users = @service.users
      expect(users).to_not be_nil
      expect(users.length).to_not be 0

      users_all = @service.users.all
      expect(users_all).to_not be_nil
      expect(users_all.length).to_not be 0

      admin_by_id = @service.users.find_by_id admin_user.first.id
      expect(admin_by_id).to_not be_nil

      expect(@service.users.find_by_name('pimpernel').length).to be 0
    end
  end

  it 'CRUD users' do
    VCR.use_cassette('idv3_user_crud') do

      # Make sure there are no existing users called foobar or baz
      ['foobar', 'baz'].each do |username|
        user = @service.users.find_by_name(username).first
        user.update(:enabled => false) if user
        user.destroy if user
      end
      expect(@service.users.find_by_name('foobar').length).to be 0
      expect(@service.users.find_by_name('baz').length).to be 0

      # Create a user called foobar
      foobar_user = @service.users.create(:name => 'foobar',
                                          :email => 'foobar@example.com',
                                          :password => 's3cret!')
      foobar_id = foobar_user.id
      expect(@service.users.find_by_name('foobar').length).to be 1

      # Rename it to baz and disable it (required so we can delete it)
      foobar_user.update(:name => 'baz', :enabled => false)
      expect(foobar_user.name).to eq 'baz'

      # Read the user freshly and check the name & enabled state
      expect(@service.users.find_by_name('baz').length).to be 1
      baz_user = @service.users.find_by_id foobar_id
      expect(baz_user).to_not be_nil
      expect(baz_user.name).to eq 'baz'
      expect(baz_user.email).to eq 'foobar@example.com'
      expect(baz_user.enabled).to be false

      # Try to create the user again
      expect { @service.users.create(:name => 'baz',
                                     :email => 'foobar@example.com',
                                     :password => 's3cret!') }.to raise_error(Excon::Errors::Conflict)

      # Delete the user
      baz_user.destroy
      # Check that the deletion worked
      expect { @service.users.find_by_id foobar_id }.to raise_error(Fog::Identity::OpenStack::NotFound)
      expect(@service.users.all.select { |user| ['foobar', 'baz'].include? user.name }.length).to be 0
      expect(@service.users.find_by_name('foobar').length).to be 0
      expect(@service.users.find_by_name('baz').length).to be 0
    end
  end

  it "CRUD & manipulate groups" do
    VCR.use_cassette('idv3_group_crud_mutation') do

      # Make sure there are no existing groups called foobar or baz
      @service.groups.all.select { |group| ['foobar', 'baz'].include? group.name }.each do |group|
        group.destroy
      end
      expect(@service.groups.all.select { |group| ['foobar', 'baz'].include? group.name }.length).to be 0

      # Create a group called foobar
      foobar_group = @service.groups.create(:name => 'foobar', :description => "Group of Foobar users")
      foobar_id = foobar_group.id
      expect(@service.groups.all.select { |group| group.name == 'foobar' }.length).to be 1

      # Rename it to baz
      foobar_group.update(:name => 'baz', :description => "Group of Baz users")
      expect(foobar_group.name).to eq 'baz'

      # Read the group freshly and check the name
      expect(@service.groups.all.select { |group| group.name == 'baz' }.length).to be 1
      baz_group = @service.groups.find_by_id foobar_id
      expect(baz_group).to_not be_nil
      expect(baz_group.name).to eq 'baz'

      # Add users to the group
      #foobar_user1 = @service.users.find_by_name('foobar1').first
      #foobar_user1.destroy if foobar_user1
      foobar_user1 = @service.users.create(:name => 'foobar1',
                                           :email => 'foobar1@example.com',
                                           :password => 's3cret!1')
      #foobar_user2 = @service.users.find_by_name('foobar2').first
      #foobar_user2.destroy if foobar_user2
      foobar_user2 = @service.users.create(:name => 'foobar2',
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
      expect { @service.groups.find_by_id foobar_id }.to raise_error(Fog::Identity::OpenStack::NotFound)
      expect(@service.groups.all.select { |group| ['foobar', 'baz'].include? group.name }.length).to be 0
    end
  end

  it "gets a token, checks it and then revokes it" do
    VCR.use_cassette('idv3_token') do
      auth = {:auth => {:identity => {:methods => %w{password},
                                      :password => {:user => {:id => ENV['OS_USER_ID']||VCR_USER_ID,
                                                              :password => ENV['OS_PASSWORD']||VCR_PASSWORD}}},
                        :scope => {:project => {:domain => {:name => ENV['OS_USER_DOMAIN_NAME']||VCR_DOMAIN_NAME},
                                                :name => ENV['OS_PROJECT_NAME']||VCR_PROJECT_NAME}}}}

      token = @service.tokens.authenticate(auth)
      expect(token).to_not be_nil

      validated_token = @service.tokens.validate token.value
      expect(validated_token).to_not be_nil

      @service.tokens.check(token.value)
      @service.tokens.revoke(token.value)

      expect { @service.tokens.check(token.value) }.to raise_error(Fog::Identity::OpenStack::NotFound)
    end
  end

  it 'authenticates with a token' do
    VCR.use_cassette('authv3_token') do
      # Setup - get a non-admin token to check by using username/password authentication to start with
      auth_url = "#{@os_auth_url}/auth/tokens"

      begin

        foobar_user = @service.users.create(:name => 'foobar_385',
                                            :email => 'foobar_demo@example.com',
                                            :domain_id => ENV['OS_USER_DOMAIN_ID'] || VCR_DOMAIN_ID,
                                            :password => 's3cret!')

        foobar_role = @service.roles.create(:name => 'foobar_role390')
        foobar_user.grant_role(foobar_role.id)

        nonadmin_v3 = Fog::Identity::OpenStack::V3.new(
            :openstack_domain_id => foobar_user.domain_id,
            :openstack_api_key => 's3cret!',
            :openstack_username => 'foobar_385',
            :openstack_region => ENV['OS_REGION_NAME']||VCR_REGION,
            :openstack_auth_url => auth_url)

        # Test - check the token validity by using it to create a new Fog::Identity::OpenStack::V3 instance
        token_check = Fog::Identity::OpenStack::V3.new(
            :openstack_auth_token => nonadmin_v3.auth_token,
            :openstack_region => ENV['OS_REGION_NAME']||VCR_REGION,
            :openstack_auth_url => auth_url)

        expect(token_check).to_not be_nil

        expect { Fog::Identity::OpenStack::V3.new(
            :openstack_auth_token => 'blahblahblah',
            :openstack_region => ENV['OS_REGION_NAME']||VCR_REGION,
            :openstack_auth_url => auth_url) }.to raise_error(Excon::Errors::NotFound)
      ensure
        # Clean up
        foobar_user = @service.users.find_by_name('foobar_385').first unless foobar_user
        foobar_user.destroy if foobar_user
        foobar_role = @service.roles.all.select { |role| role.name == 'foobar_role390' }.first unless foobar_role
        foobar_role.destroy if foobar_role
      end

    end
  end

  it "lists domains" do
    VCR.use_cassette('idv3_domain') do

      domains = @service.domains
      expect(domains).to_not be_nil
      expect(domains.length).to_not be 0

      domains_all = @service.domains.all
      expect(domains_all).to_not be_nil
      expect(domains_all.length).to_not be 0

      default_domain = @service.domains.find_by_id ENV['OS_USER_DOMAIN_ID']||VCR_DOMAIN_ID
      expect(default_domain).to_not be_nil

      expect { @service.domains.find_by_id 'atlantis' }.to raise_error(Fog::Identity::OpenStack::NotFound)
    end
  end

  it "CRUD domains" do
    VCR.use_cassette('idv3_domain_crud') do

      begin
        # Create a domain called foobar
        foobar_domain = @service.domains.create(:name => 'foobar')
        foobar_id = foobar_domain.id
        expect(@service.domains.all(:name => 'foobar').length).to be 1

        # Rename it to baz and disable it (required so we can delete it)
        foobar_domain.update(:name => 'baz', :enabled => false)
        expect(foobar_domain.name).to eq 'baz'

        # Read the domain freshly and check the name & enabled state
        expect(@service.domains.all(:name => 'baz').length).to be 1
        baz_domain = @service.domains.find_by_id foobar_id
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
        expect { @service.domains.find_by_id foobar_id }.to raise_error(Fog::Identity::OpenStack::NotFound) if foobar_id
        ['foobar', 'baz'].each do |domain_name|
          expect(@service.domains.all(:name => domain_name).length).to be 0
        end
      end
    end
  end

  it "Manipulates roles on domains" do
    # Note that the domain is implicit in the user operations here

    VCR.use_cassette('idv3_domain_roles_mutation') do
      begin
        foobar_user = @service.users.create(:name => 'foobar_role_user',
                                            :email => 'foobar@example.com',
                                            :password => 's3cret!')

        # User has no roles initially
        expect(foobar_user.roles.length).to be 0

        # Create a role and add it to the user in the user's domain
        foobar_role = @service.roles.create(:name => 'foobar_role')
        foobar_user.grant_role(foobar_role.id)
        expect(foobar_user.roles.length).to be 1
        assignments = @service.role_assignments.all(:user_id => foobar_user.id)
        expect(assignments.length).to be 1
        expect(assignments.first.role['id']).to eq foobar_role.id
        expect(assignments.first.user['id']).to eq foobar_user.id
        expect(assignments.first.scope['domain']['id']).to eq foobar_user.domain_id
        expect(assignments.first.links['assignment'].end_with? "/v3/domains/#{foobar_user.domain_id}/users/#{foobar_user.id}/roles/#{foobar_role.id}").to be true

        # Quick test of @service.role_assignments.all while we're at it
        all_assignments = @service.role_assignments.all
        expect(all_assignments.length).to be >= 1

        # Check that the user has the role
        expect(foobar_user.check_role(foobar_role.id)).to be true

        # Revoke the role from the user
        foobar_user.revoke_role(foobar_role.id)
        expect(foobar_user.check_role(foobar_role.id)).to be false
      ensure
        foobar_user = @service.users.find_by_name('foobar_role_user').first unless foobar_user
        foobar_user.destroy if foobar_user
        foobar_role = @service.roles.all.select { |role| role.name == 'foobar_role' }.first unless foobar_role
        foobar_role.destroy if foobar_role
      end

    end
  end

  it "Manipulates roles on domain groups" do
    VCR.use_cassette('idv3_domain_group_roles_mutation') do

      begin
        # Create a domain called foobar
        foobar_domain = @service.domains.create(:name => 'd-foobar')

        # Create a group in this domain
        foobar_group = @service.groups.create(:name => 'g-foobar',
                                              :description => "Group of Foobar users",
                                              :domain_id => foobar_domain.id)

        # Create a user in the domain
        foobar_user = @service.users.create(:name => 'u-foobar_foobar',
                                            :email => 'foobar@example.com',
                                            :password => 's3cret!',
                                            :domain_id => foobar_domain.id)

        # User has no roles initially
        expect(foobar_user.roles.length).to be 0

        # Create a role and add it to the domain group
        foobar_role = @service.roles.all.select { |role| role.name == 'foobar_role' }.first
        foobar_role.destroy if foobar_role
        foobar_role = @service.roles.create(:name => 'foobar_role')

        foobar_group.grant_role foobar_role.id
        expect(foobar_group.roles.length).to be 1

        # Add user to the group and check that it inherits the role
        expect(foobar_user.check_role foobar_role.id).to be false
        expect(@service.role_assignments.all(:user_id => foobar_user.id, :effective => true).length).to be 0
        foobar_group.add_user foobar_user.id
        expect(foobar_user.check_role foobar_role.id).to be false # Still false in absolute assignment terms
        assignments = @service.role_assignments.all(:user_id => foobar_user.id, :effective => true)
        expect(assignments.length).to be 1
        expect(assignments.first.role['id']).to eq foobar_role.id
        expect(assignments.first.user['id']).to eq foobar_user.id
        expect(assignments.first.scope['domain']['id']).to eq foobar_user.domain_id
        expect(assignments.first.links['assignment'].end_with? "/v3/domains/#{foobar_domain.id}/groups/#{foobar_group.id}/roles/#{foobar_role.id}").to be true
        expect(assignments.first.links['membership'].end_with? "/v3/groups/#{foobar_group.id}/users/#{foobar_user.id}").to be true

        group_assignments = @service.role_assignments.all(:group_id => foobar_group.id)
        expect(group_assignments.length).to be 1
        expect(group_assignments.first.role['id']).to eq foobar_role.id
        expect(group_assignments.first.group['id']).to eq foobar_group.id
        expect(group_assignments.first.scope['domain']['id']).to eq foobar_user.domain_id
        expect(group_assignments.first.links['assignment'].end_with? "/v3/domains/#{foobar_domain.id}/groups/#{foobar_group.id}/roles/#{foobar_role.id}").to be true

        # Revoke the role from the group and check the user no longer has it
        foobar_group.revoke_role foobar_role.id
        expect(@service.role_assignments.all(:user_id => foobar_user.id, :effective => true).length).to be 0
      ensure
        # Clean up
        foobar_user = @service.users.find_by_name('u-foobar_foobar').first unless foobar_user
        foobar_user.destroy if foobar_user
        foobar_group = @service.groups.all.select { |group| group.name == 'g-foobar' }.first unless foobar_group
        foobar_group.destroy if foobar_group
        foobar_role = @service.roles.all.select { |role| role.name == 'foobar_role' }.first unless foobar_role
        foobar_role.destroy if foobar_role
        foobar_domain = @service.domains.all.select { |domain| domain.name == 'd-foobar' }.first unless foobar_domain
        foobar_domain.update(:enabled => false) if foobar_domain
        foobar_domain.destroy if foobar_domain
      end
    end
  end

  it "lists roles" do
    VCR.use_cassette('idv3_role') do

      roles = @service.roles
      expect(roles).to_not be_nil
      expect(roles.length).to_not be 0

      roles_all = @service.roles.all
      expect(roles_all).to_not be_nil
      expect(roles_all.length).to_not be 0

      role_by_id = @service.roles.find_by_id roles_all.first.id
      expect(role_by_id).to_not be_nil

      expect { @service.roles.find_by_id 'atlantis' }.to raise_error(Fog::Identity::OpenStack::NotFound)
    end
  end

  it "CRUD roles" do
    VCR.use_cassette('idv3_role_crud') do

      begin
        # Create a role called foobar
        foobar_role = @service.roles.create(:name => 'foobar23')
        foobar_id = foobar_role.id
        expect(@service.roles.all(:name => 'foobar23').length).to be 1

        # Rename it to baz
        foobar_role.update(:name => 'baz23')
        expect(foobar_role.name).to eq 'baz23'

        # Read the role freshly and check the name & enabled state
        expect(@service.roles.all(:name => 'baz23').length).to be 1
        baz_role = @service.roles.find_by_id foobar_id
        expect(baz_role).to_not be_nil
        expect(baz_role.name).to eq 'baz23'
        baz_role.destroy
        baz_role = nil
        # Check that the deletion worked
        expect { @service.roles.find_by_id foobar_id }.to raise_error(Fog::Identity::OpenStack::NotFound) if foobar_id
        ['foobar23', 'baz23'].each do |role_name|
          expect(@service.roles.all(:name => role_name).length).to be 0
        end
      ensure
        # Delete the roles
        foobar_by_name = @service.roles.all(:name => 'foobar23').first
        foobar_by_name.destroy if foobar_by_name
        baz_by_name = @service.roles.all(:name => 'baz23').first
        baz_by_name.destroy if baz_by_name
      end
    end
  end

  it "lists projects" do
    VCR.use_cassette('idv3_project') do

      projects = @service.projects
      expect(projects).to_not be_nil
      expect(projects.length).to_not be 0

      projects_all = @service.projects.all
      expect(projects_all).to_not be_nil
      expect(projects_all.length).to_not be 0
      project_byid = @service.projects.find_by_id projects_all.first.id
      expect(project_byid).to_not be_nil

      expect { @service.projects.find_by_id 'atlantis' }.to raise_error(Fog::Identity::OpenStack::NotFound)
    end
  end

  it "CRUD projects" do
    VCR.use_cassette('idv3_project_crud') do

      default_domain = @service.domains.find_by_id ENV['OS_USER_DOMAIN_ID']||VCR_DOMAIN_ID

      begin
        # Create a project called foobar - should not work without domain id?
        foobar_project = @service.projects.create(:name => 'p-foobar46')
        foobar_id = foobar_project.id
        expect(@service.projects.all(:name => 'p-foobar46').length).to be 1
        expect(foobar_project.domain_id).to eq default_domain.id

        # Rename it to baz and disable it (required so we can delete it)
        foobar_project.update(:name => 'p-baz46', :enabled => false)
        expect(foobar_project.name).to eq 'p-baz46'

        # Read the project freshly and check the name & enabled state
        expect(@service.projects.all(:name => 'p-baz46').length).to be 1
        baz_project = @service.projects.find_by_id foobar_id
        expect(baz_project).to_not be_nil
        expect(baz_project.name).to eq 'p-baz46'
        expect(baz_project.enabled).to be false
      ensure
        # Delete the project
        baz_project.destroy

        # Check that the deletion worked
        expect { @service.projects.find_by_id foobar_id }.to raise_error(Fog::Identity::OpenStack::NotFound)
        ['p-foobar46', 'p-baz46'].each do |project_name|
          expect(@service.projects.all(:name => project_name).length).to be 0
        end
      end
    end
  end

  it "CRUD & list hierarchical projects" do
    VCR.use_cassette('idv3_project_hier_crud_list') do

      default_domain = @service.domains.find_by_id ENV['OS_USER_DOMAIN_ID']||VCR_DOMAIN_ID

      begin
        # Create a project called foobar
        foobar_project = @service.projects.create(:name => 'p-foobar67')
        foobar_id = foobar_project.id

        # Create a sub-project called baz
        baz_project = @service.projects.create(:name => 'p-baz67', :parent_id => foobar_id)
        baz_id = baz_project.id

        expect(baz_project.parent_id).to eq foobar_id

        # Read the project freshly and check the parent_id
        fresh_baz_project = @service.projects.all(:name => 'p-baz67').first
        expect(fresh_baz_project).to_not be_nil
        expect(fresh_baz_project.parent_id).to eq foobar_id

        # Create another sub-project called boo
        boo_project = @service.projects.create(:name => 'p-boo67', :parent_id => foobar_id)
        boo_id = boo_project.id

        # Create a sub-project of boo called booboo
        booboo_project = @service.projects.create(:name => 'p-booboo67', :parent_id => boo_id)
        booboo_id = booboo_project.id

        # Make sure we have a role on all these projects (needed for subtree_as_list and parents_as_list)
        prj_role = @service.roles.create(:name => 'r-project67')
        [foobar_project, baz_project, boo_project, booboo_project].each do |project|
          project.grant_role_to_user(prj_role.id, @service.current_user_id)
        end

        # Get the children of foobar, as a tree of IDs
        foobar_kids = @service.projects.find_by_id(foobar_id, :subtree_as_ids).subtree
        expect(foobar_kids.keys.length).to eq 2

        boo_index = foobar_kids.keys.index boo_id
        expect(boo_index).to_not be_nil

        foobar_child_id = foobar_kids.keys[boo_index]
        expect(foobar_kids[foobar_child_id].length).to eq 1
        foobar_grandchild_id = foobar_kids[foobar_child_id].keys.first
        expect(foobar_grandchild_id).to eq booboo_id

        # Get the children of foobar, as a list of objects
        foobar_kids = @service.projects.find_by_id(foobar_id, :subtree_as_list).subtree
        expect(foobar_kids.length).to eq 3
        expect([foobar_kids[0].id,foobar_kids[1].id,foobar_kids[2].id].sort
        ).to eq [baz_id, boo_id, booboo_id].sort

        # Create a another sub-project of boo called fooboo and check that it appears in the parent's subtree
        fooboo_project = @service.projects.create(:name => 'p-fooboo67', :parent_id => boo_id)
        fooboo_id = fooboo_project.id
        fooboo_project.grant_role_to_user(prj_role.id, @service.current_user_id)
        foobar_new_kids = @service.projects.find_by_id(foobar_id, :subtree_as_list).subtree
        expect(foobar_new_kids.length).to eq 4

        # Get the parents of booboo, as a tree of IDs
        booboo_parents = @service.projects.find_by_id(booboo_id, :parents_as_ids).parents
        expect(booboo_parents.keys.length).to eq 1
        booboo_parent_id = booboo_parents.keys.first
        expect(booboo_parents[booboo_parent_id].length).to eq 1
        booboo_grandparent_id = booboo_parents[booboo_parent_id].keys.first
        expect(booboo_grandparent_id).to eq foobar_id
        expect(booboo_parents[booboo_parent_id][booboo_grandparent_id]).to be_nil

        # Get the parents of booboo, as a list of objects
        booboo_parents = @service.projects.find_by_id(booboo_id, :parents_as_list).parents
        expect(booboo_parents.length).to eq 2
        expect([booboo_parents[0].id,booboo_parents[1].id].sort).to eq [foobar_id, boo_id].sort
      ensure
        # Delete the projects
        fooboo_project.destroy if fooboo_project
        booboo_project.destroy if booboo_project
        boo_project.destroy if boo_project
        baz_project.destroy if baz_project
        foobar_project.destroy if foobar_project
        prj_role = @service.roles.all(:name => 'r-project67').first unless prj_role
        prj_role.destroy if prj_role
        # Check that the deletion worked
        expect { @service.projects.find_by_id foobar_id }.to raise_error(Fog::Identity::OpenStack::NotFound) if foobar_id
        ['p-booboo67', 'p-fooboo67', 'p-boo67', 'p-baz67', 'p-foobar67'].each do |project_name|
          prj = @service.projects.all(:name => project_name).first
          prj.destroy if prj
          expect(@service.projects.all(:name => project_name).length).to be 0
        end
      end
    end
  end

  it "Manipulates projects - add/remove users/groups via role assignment/revocation" do
    VCR.use_cassette('idv3_project_group_user_roles_mutation') do

      # Make sure there is no existing project called foobar
      @service.projects.all(:name => 'p-foobar69').each do |project|
        project.update(:enabled => false)
        project.destroy
      end
      expect(@service.projects.all(:name => 'p-foobar69').length).to be 0

      begin
        # Create a project called foobar
        foobar_project = @service.projects.create(:name => 'p-foobar69')
        # Create a role called baz
        @service.roles.all(:name => 'baz').each do |role|
          role.update(:enabled => false)
          role.destroy
        end
        baz_role = @service.roles.create(:name => 'baz69')

        # Create a user
        foobar_user = @service.users.create(:name => 'u-foobar69',
                                            :email => 'foobar@example.com',
                                            :password => 's3cret!')

        # Create a group and add the user to it
        foobar_group = @service.groups.create(:name => 'g-foobar69',
                                              :description => "Group of Foobar users")
        foobar_group.add_user foobar_user.id

        # User has no projects initially
        expect(foobar_user.projects.length).to be 0
        expect(@service.role_assignments.all(:user_id => foobar_user.id,
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

        expect(@service.role_assignments.all(:user_id => foobar_user.id,
                                             :project_id => foobar_project.id,
                                             :effective => true).length).to be 0

        # Grant role to the group in the new project - this assigns the project to the group
        foobar_project.grant_role_to_group(baz_role.id, foobar_group.id)
        expect(foobar_project.check_group_role(foobar_group.id, baz_role.id)).to be true
        expect(foobar_project.group_roles(foobar_group.id).length).to be 1

        # Now we check that a user has the role in that project
        assignments = @service.role_assignments.all(:user_id => foobar_user.id,
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

      services = @service.services
      expect(services).to_not be_nil
      expect(services.length).to_not be 0

      services_all = @service.services.all
      expect(services_all).to_not be_nil
      expect(services_all.length).to_not be 0

      some_service = @service.services.find_by_id services_all.first.id
      expect(some_service).to_not be_nil

      expect { @service.services.find_by_id 'atlantis' }.to raise_error(Fog::Identity::OpenStack::NotFound)
    end
  end

  it "CRUD services" do
    VCR.use_cassette('idv3_services_crud') do

      all_services = @service.services.all

      begin
        # Create a service called foobar
        foobar_service = @service.services.create(:type => 'volume', :name => 'foobar')
        foobar_id = foobar_service.id
        expect(@service.services.all(:type => 'volume').select { |service| service.name == 'foobar' }.length).to be 1

        # Rename it to baz
        foobar_service.update(:name => 'baz')
        expect(foobar_service.name).to eq 'baz'

        # Read the service freshly and check the name
        expect(@service.services.all.select { |service| service.name == 'baz' }.length).to be 1
        baz_service = @service.services.find_by_id foobar_id
        expect(baz_service).to_not be_nil
        expect(baz_service.name).to eq 'baz'
        expect(baz_service.type).to eq 'volume'
      ensure
        # Delete the service
        baz_service.destroy if baz_service

        # Check that the deletion worked
        expect { @service.services.find_by_id foobar_id }.to raise_error(Fog::Identity::OpenStack::NotFound) if foobar_id
        expect(@service.services.all.select { |service| ['foobar', 'baz'].include? service.name }.length).to be 0
      end
    end
  end

  it "lists endpoints" do
    VCR.use_cassette('idv3_endpoint') do

      endpoints = @service.endpoints
      expect(endpoints).to_not be_nil
      expect(endpoints.length).to_not be 0

      endpoints_all = @service.endpoints.all
      expect(endpoints_all).to_not be_nil
      expect(endpoints_all.length).to_not be 0

      some_endpoint = @service.endpoints.find_by_id endpoints_all.first.id
      expect(some_endpoint).to_not be_nil

      expect { @service.endpoints.find_by_id 'atlantis' }.to raise_error(Fog::Identity::OpenStack::NotFound)
    end
  end

  it "CRUD endpoints" do
    VCR.use_cassette('idv3_endpoints_crud') do

      service = @service.services.all.first
      all_endpoints = @service.endpoints.all

      begin
        # Create a endpoint called foobar
        foobar_endpoint = @service.endpoints.create(:service_id => service.id,
                                                    :interface => 'internal',
                                                    :name => 'foobar',
                                                    :url => 'http://example.com/foobar',
                                                    :enabled => false)
        foobar_id = foobar_endpoint.id
        expect(@service.endpoints.all(:interface => 'internal').select { |endpoint| endpoint.name == 'foobar' }.length).to be 1

        # Rename it to baz
        foobar_endpoint.update(:name => 'baz', :url => 'http://example.com/baz')
        expect(foobar_endpoint.name).to eq 'baz'
        expect(foobar_endpoint.url).to eq 'http://example.com/baz'

        # Read the endpoint freshly and check the name
        expect(@service.endpoints.all(:interface => 'internal').select { |endpoint| endpoint.name == 'baz' }.length).to be 1
        baz_endpoint = @service.endpoints.find_by_id foobar_id
        expect(baz_endpoint).to_not be_nil
        expect(baz_endpoint.name).to eq 'baz'
        expect(baz_endpoint.url).to eq 'http://example.com/baz'
        expect(baz_endpoint.interface).to eq 'internal'
      ensure
        # Delete the endpoint
        baz_endpoint.destroy

        # Check that the deletion worked
        expect { @service.endpoints.find_by_id foobar_id }.to raise_error(Fog::Identity::OpenStack::NotFound)
        expect(@service.endpoints.all.select { |endpoint| ['foobar', 'baz'].include? endpoint.name }.length).to be 0
      end
    end
  end

  it "lists OS credentials" do
    VCR.use_cassette('idv3_credential') do
      credentials = @service.os_credentials
      expect(credentials).to_not be_nil

      credentials_all = @service.os_credentials.all
      expect(credentials_all).to_not be_nil

      expect { @service.os_credentials.find_by_id 'atlantis' }.to raise_error(Fog::Identity::OpenStack::NotFound)
    end
  end

  it "CRUD OS credentials" do
    VCR.use_cassette('idv3_credential_crud') do

      begin
        # Create a user
        foobar_user = @service.users.create(:name => 'u-foobar_cred',
                                            :email => 'foobar@example.com',
                                            :password => 's3cret!')
        project = @service.projects.all.first

        access_key = '9c4e774a-f644-498f-90c4-970b3f817fc5'
        secret_key = '7e084117-b13d-4656-9eca-85376b690897'

        # OpenStack Keystone requires the blob to be a JSON string - i.e. not JSON, but a string containing JSON :-/
        blob_json = {:access => access_key,
                     :secret => secret_key}.to_json

        # Make sure there are no existing ec2 credentials
        @service.os_credentials.all.select { |credential| credential.type == 'foo' || credential.type == 'ec2' }.each do |credential|
          credential.destroy
        end
        expect(@service.os_credentials.all.select { |credential| credential.type == 'ec2' }.length).to be 0

        # Create a credential
        foo_credential = @service.os_credentials.create(:type => 'ec2',
                                                        :project_id => project.id,
                                                        :user_id => foobar_user.id,
                                                        :blob => blob_json)
        credential_id = foo_credential.id
        expect(@service.os_credentials.all.select { |credential| credential.type == 'ec2' }.length).to be 1

        # Update secret key
        new_secret_key = '62307bcd-ca3c-47ae-a114-27a6cadb5bc9'
        new_blob_json = {:access => access_key,
                         :secret => new_secret_key}.to_json
        foo_credential.update(:blob => new_blob_json)
        expect(JSON.parse(foo_credential.blob)['secret']).to eq new_secret_key

        # Read the credential freshly and check the secret key
        expect(@service.os_credentials.all.select { |credential| credential.type == 'ec2' }.length).to be 1
        updated_credential = @service.os_credentials.find_by_id credential_id
        expect(updated_credential).to_not be_nil
        expect(updated_credential.type).to eq 'ec2'
        expect(JSON.parse(updated_credential.blob)['secret']).to eq new_secret_key

      ensure
        foobar_user = @service.users.find_by_name('u-foobar_cred').first unless foobar_user
        foobar_user.destroy if foobar_user
        # Delete the credential
        begin
          updated_credential.destroy if updated_credential
          foo_credential.destroy if foo_credential
        rescue
          false
        end

        # Check that the deletion worked
        expect { @service.os_credentials.find_by_id credential_id }.to raise_error(Fog::Identity::OpenStack::NotFound) if credential_id
        expect(@service.os_credentials.all.select { |credential| credential.type == 'ec2' }.length).to be 0
      end
    end
  end

  it "lists policies" do
    VCR.use_cassette('idv3_policy') do
      policies = @service.policies
      expect(policies).to_not be_nil
      expect(policies.length).to be 0

      policies_all = @service.policies.all
      expect(policies_all).to_not be_nil
      expect(policies_all.length).to be 0

      expect { @service.policies.find_by_id 'atlantis' }.to raise_error(Fog::Identity::OpenStack::NotFound)
    end
  end

  it "CRUD policies" do
    VCR.use_cassette('idv3_policy_crud') do

      blob = {'foobar_user' => ['role:compute-user']}.to_json

      # Make sure there are no existing policies
      expect(@service.policies.all.select { |policy| policy.type == 'application/json' }.length).to be 0

      # Create a policy
      foo_policy = @service.policies.create(:type => 'application/json',
                                            :blob => blob)
      policy_id = foo_policy.id
      expect(@service.policies.all.select { |policy| policy.type == 'application/json' }.length).to be 1

      # Update policy blob
      new_blob = {'baz_user' => ['role:compute-user']}.to_json
      foo_policy.update(:blob => new_blob)
      expect(foo_policy.blob).to eq new_blob

      # Read the policy freshly and check the secret key
      expect(@service.policies.all.select { |policy| policy.type == 'application/json' }.length).to be 1
      updated_policy = @service.policies.find_by_id policy_id
      expect(updated_policy).to_not be_nil
      expect(updated_policy.type).to eq 'application/json'
      expect(updated_policy.blob).to eq new_blob

      # Delete the policy
      updated_policy.destroy

      # Check that the deletion worked
      expect { @service.policies.find_by_id policy_id }.to raise_error(Fog::Identity::OpenStack::NotFound)
      expect(@service.policies.all.select { |policy| policy.type == 'application/json' }.length).to be 0
    end
  end

end
