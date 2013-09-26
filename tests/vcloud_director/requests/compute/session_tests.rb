Shindo.tests('Compute::VcloudDirector | session requests', ['vclouddirector']) do

  SESSION_FORMAT = {
    :xmlns => 'http://www.vmware.com/vcloud/v1.5',
    :xmlns_xsi => 'http://www.w3.org/2001/XMLSchema-instance',
    :user => String,
    :org => String,
    :type => 'application/vnd.vmware.vcloud.session+xml',
    :href => String,
    :xsi_schemaLocation => String,
    :Link => [{
      :rel => String,
      :type => String,
      :href => String
    }]
  }

  @service = Fog::Compute::VcloudDirector.new

  tests('#post_login_sessions').formats(SESSION_FORMAT) do
    pending
    @service.login.body # calls post_login_sessions
  end

  tests('#get_current_session').formats(SESSION_FORMAT) do
    @service.get_current_session.body
  end

end
