def test_domain
  'fog-dream.com'
end

def do_not_delete_record
  "do-not-delete.#{test_domain}"
end

## Cleanup
# We need to have at least one record defined for the Dreamhost DNS api to work
# or you will get a no_such_zone runtime error
# The first record needs to be created using the Dreamhost Web panel AFAIK
#
def cleanup_records
  Fog::DNS[:dreamhost].records.each do |r|
    # Do not delete the 'do-not-delete' record, we need it for the tests
    r.destroy if r.name =~ /#{test_domain}/ and r.name != do_not_delete_record
  end
end
