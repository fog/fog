Shindo.tests('Fog::Compute[:slicehost] | backup requests', ['slicehost']) do

  @backup_format = {
    'date'      => String,
    'id'        => Integer,
    'name'      => String,
    'slice-id'  => Integer
  }

  tests('success') do

    tests('#get_backups').formats({ 'backups' => [@backup_format] }) do
      pending if Fog.mocking?
      Fog::Compute[:slicehost].get_backups.body
    end

  end
end
