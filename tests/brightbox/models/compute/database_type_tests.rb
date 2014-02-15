Shindo.tests("Fog::Compute[:brightbox] | DatabaseType model", ["brightbox"]) do
  pending if Fog.mocking?

  @service = Fog::Compute[:brightbox]

  tests("success") do
    tests("#all") do
      @database_types = @service.database_types.all
      test("returns results") { !@database_types.empty? }
    end

    @sample_identifier = @database_types.first.id
    pending if @sample_identifier.nil?

    tests("#get(#{@sample_identifier})") do
      @database_type = @service.database_types.get(@sample_identifier)

      test("disk is not nil") do
        !@database_type.disk.nil?
      end

      test("ram is not nil") do
        !@database_type.ram.nil?
      end
    end
  end
end
