Shindo.tests('Slicehost#get_backups', 'slicehost') do
  tests('success') do

    tests('#get_backups').formats({ 'backups' => [Slicehost::Formats::BACKUP] }) do
      Slicehost[:slices].get_backups.body
    end

  end
end
