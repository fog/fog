Shindo.tests('Linode::DNS | records collection', ['linode']) do

  records_tests(Linode[:dns], {}, false)

end
