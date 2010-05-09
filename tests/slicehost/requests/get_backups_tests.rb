Shindo.tests('Slicehost#get_backups', 'slicehost') do
  tests('success') do

    before do
      @data = Slicehost[:slices].get_backups.body
    end

    test('has proper output format') do
      has_format(@data, { 'backups' => [Slicehost::Formats::BACKUP] })
    end

  end
end
