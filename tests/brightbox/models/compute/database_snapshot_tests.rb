Shindo.tests("Fog::Compute[:brightbox] | DatabaseSnapshot model", ["brightbox"]) do
  pending if Fog.mocking?

  @service = Fog::Compute[:brightbox]

  tests("success") do
    tests("#all") do
      test("returns results") do
        @database_snapshots = @service.database_snapshots.all
        !@database_snapshots.empty?
      end
    end

    pending if @database_snapshots.empty?
    @sample_identifier = @database_snapshots.first.identity
    tests("#get('#{@sample_identifier}')") do
      @database_snapshot = @service.database_snapshots.get(@sample_identifier)
    end

    # @database_snapshot.wait_for { ready? }

    # tests("#destroy") do
    #   @database_snapshot.destroy
    # end
  end
end
