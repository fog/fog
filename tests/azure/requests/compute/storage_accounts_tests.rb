Shindo.tests("Fog::Compute[:azure] | storage accounts request", ["azure", "compute"]) do

  tests("#storage_accounts") do
    storage_accounts = Fog::Compute[:azure].storage_accounts
    storage_accounts = [storage_account] if storage_accounts.empty?

    test "returns a Array" do
      storage_accounts.is_a? Array
    end

    test("should return valid storage account name") do
      storage_accounts.first.name.is_a? String
    end

    test("should return records") do
      storage_accounts.size >= 1
    end
  end

end
