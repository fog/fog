Shindo.tests('Fog::DNS[:dreamhost] | list_records request', ['dreamhost', 'dns']) do

  tests("success") do

    response = Fog::DNS[:dreamhost].list_records

    test("should return 200") do
      if response.status == 200
        @records = response.body["data"]
      end
      (response.status == 200) and (response.body.size == 2)
    end

    test("data should be an Array") do
      @records.is_a? Array
    end

    tests("should return records") do
      %w{type zone value comment record}.each do |elem|
        test("with #{elem}") do
          @records.first[elem].is_a? String
        end
      end
    end

  end

  # helper
  cleanup_records

end
