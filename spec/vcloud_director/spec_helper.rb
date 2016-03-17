if ENV["FOG_MOCK"] == "true"
  Fog.mock!
end

if Fog.mock?
  Fog.credentials = {
    :vcloud_director_host             => 'vcloud-director-host',
    :vcloud_director_password         => 'vcloud_director_password',
    :vcloud_director_username         => 'vcd_user@vcd_org_name',
  }.merge(Fog.credentials)
end