Shindo.tests('Fog::DNS[:rackspace] | DNS requests', ['rackspace', 'dns']) do

  @domain = ''
  @new_zones = []
  @new_records =[]

  @service = Fog::DNS[:rackspace]

  LIST_DOMAIN_FORMAT = {
    'domains' => [
      {
        'name' => String,
        'id' => Integer,
        'accountId' => Integer,
        'updated' => String,
        'created' => String
      }
    ],
    'totalEntries' => Integer,
    'links' => [
      {
        'rel' => String,
        'href' => String
      }
    ]
  }

  tests( 'success') do
    tests('list_domains').formats(LIST_DOMAIN_FORMAT) do
      @service.list_domains.body
    end

    tests('list_domains :limit => 5, :offset => 10, :domain => "hartsock" --> All possible attributes').formats(LIST_DOMAIN_FORMAT) do
      @service.list_domains(:limit => 5, :offset => 10, :domain => 'hartsock').body
    end
  end

  tests( 'failure') do
    tests('list_domains :limit => 5, :offset => 8').raises(Fog::Rackspace::Errors::BadRequest) do
      @service.list_domains :limit => 5, :offset => 8
    end
  end
end
