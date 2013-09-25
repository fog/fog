Shindo.tests("Fog::Compute[:brightbox] | Account model", ["brightbox"]) do

  pending if Fog.mocking?

  @account = Fog::Compute[:brightbox].account

  tests("success") do

    tests("#reset_ftp_password") do
      pending if Fog.mocking?
      test("original ftp password is blanked") { @account.library_ftp_password.nil? }
      @new_password = @account.reset_ftp_password
      test("new ftp password was not nil") { !@new_password.nil? }
      test("new ftp password is set") { @account.library_ftp_password == @new_password }
    end
  end
end
