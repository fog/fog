Shindo.tests("Fog::DNS[:dreamhost] | records", ['dreamhost', 'dns']) do

  service = Fog::DNS[:dreamhost]

  tests('#all') do
    records = service.records

    test('should be an array') { records.is_a? Array }

    test('should not be empty') { !records.empty? }

    tests('should list Fog::DNS::Dreamhost::Record') do
      records.each do |r|
        test("as records") { r.is_a?(Fog::DNS::Dreamhost::Record) }
      end
    end
  end

  tests('#get') do
    tests('should fetch a record') do
      record = service.records.get do_not_delete_record
      test('should be a Fog::DNS::Dreamhost::Record') do
        record.is_a? Fog::DNS::Dreamhost::Record
      end
    end
  end

end
