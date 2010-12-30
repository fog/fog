Shindo.tests('Linode::DNS | record model', ['linode']) do

  record_tests(Linode[:dns], {}, false)

end
