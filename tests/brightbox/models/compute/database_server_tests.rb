Shindo.tests("Fog::Compute[:brightbox] | DatabaseServer model", ["brightbox"]) do
  pending if Fog.mocking?

  @service = Fog::Compute[:brightbox]

  tests("success") do
    tests("#create") do
      test("a new database server is returned") do
        @database_server = @service.database_servers.create
        !@database_server.nil?
      end

      test("state is not nil") do
        !@database_server.state.nil?
      end

      test("database_version is not nil") do
        !@database_server.database_version.nil?
      end

      test("admin_username is not nil") do
        !@database_server.admin_username.nil?
      end

      test("admin_password is not nil") do
        !@database_server.admin_password.nil?
      end
    end

    @sample_identifier = @database_server.id
    pending if @sample_identifier.nil?

    tests("#all") do
      test("returns results") do
        @database_servers = @service.database_servers.all
        @database_servers.any? do |dbs|
          dbs.identity == @database_server.identity
        end
      end
    end

    tests("#get('#{@sample_identifier}')") do
      @database_server = @service.database_servers.get(@sample_identifier)

      @database_server.wait_for { ready? }

      test("admin_username is not nil") do
        !@database_server.admin_username.nil?
      end

      test("admin_password is nil") do
        @database_server.admin_password.nil?
      end
    end

    @database_server.wait_for { ready? }

    test("#snapshot") do
      @database_server.snapshot
    end

    tests("#destroy") do
      @database_server.destroy
    end
  end
end
