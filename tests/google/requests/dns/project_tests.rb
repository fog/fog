Shindo.tests('Fog::DNS[:google] | project requests', ['google']) do
  @dns = Fog::DNS[:google]

  @project_quota_format = {
    'kind' => String,
    'managedZones' => Integer,
    'rrsetsPerManagedZone' => Integer,
    'rrsetAdditionsPerChange' => Integer,
    'rrsetDeletionsPerChange'=>Integer,
    'totalRrdataSizePerChange' => Integer,
    'resourceRecordsPerRrset' => Integer,
  }

  @get_project_format = {
    'kind' => String,
    'number' => String,
    'id' => String,
    'quota' => @project_quota_format,
  }

  tests('success') do

    tests('#get_project').formats(@get_project_format) do
      @dns.get_project(@dns.project).body
    end

  end

end
