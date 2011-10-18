SUBDOMAIN_FORMAT = {
  'name' => String,
  'id' => Integer,
  'created' => String,
  'updated' => String
}

LIST_SUBDOMAINS_FORMAT = {
  'domains' => [SUBDOMAIN_FORMAT],
  'totalEntries' => Integer
}

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

RECORD_FORMAT = {
  'name' => String,
  'id' => String,
  'type' => String,
  'data' => String,
  'updated' => String,
  'created' => String,
  'ttl' => Integer,
  'priority' => Fog::Nullable::Integer
}

RECORD_LIST_FORMAT = {
  'records' => [RECORD_FORMAT],
  #In some cases this is returned (domain details) and in some cases it isn't (create domain).  Marking as nullable.
  'totalEntries' => Fog::Nullable::Integer
}

NAME_SERVERS_FORMAT = [{
  'name' => String
}]

BASIC_DOMAIN_DETAIL_FORMAT = {
  'name' => String,
  'id' => Integer,
  'accountId' => Integer,
  'updated' => String,
  'created' =>String,
  'ttl' => Integer,
  'emailAddress' => String,
  'nameservers' => NAME_SERVERS_FORMAT
}

LIST_DOMAIN_DETAILS_WITH_RECORDS = BASIC_DOMAIN_DETAIL_FORMAT.merge({
  'recordsList' => RECORD_LIST_FORMAT
})

LIST_DOMAIN_DETAILS_WITH_RECORDS_AND_SUBDOMAINS_FORMAT = BASIC_DOMAIN_DETAIL_FORMAT.merge({
  'recordsList'     => RECORD_LIST_FORMAT,
  'subdomains'      => {
    'domains'   => [{
      'created' => String,
      'name'    => String,
      'id'      => Integer,
      'updated' => String
    }],
    'totalEntries'  => Integer
  }
})

LIST_DOMAIN_DETAILS_WITHOUT_RECORDS_AND_SUBDOMAINS_FORMAT = BASIC_DOMAIN_DETAIL_FORMAT

CREATE_DOMAINS_FORMAT = {
  'domains' => [
    BASIC_DOMAIN_DETAIL_FORMAT.merge({
      'recordsList' => RECORD_LIST_FORMAT
    })
  ]
}

def wait_for(service, response)
  job_id = response.body['jobId']
  Fog.wait_for do
    response = service.callback(job_id)
    response.body['status'] != 'RUNNING'
  end
  response
end

def domain_tests(service, domain_attributes)
  tests("create_domains([#{domain_attributes}])").formats(CREATE_DOMAINS_FORMAT) do
    response = wait_for service, service.create_domains([domain_attributes])
    @domain_details = response.body['response']['domains']
    @domain_id = @domain_details[0]['id']
    response.body['response']
  end

  begin
    if block_given?
      yield
    end
  ensure
    tests("remove_domain('#{@domain_id}')").succeeds do
      wait_for service, service.remove_domain(@domain_id)
    end
  end
end

def domains_tests(service, domains_attributes, custom_delete = false)
  tests("create_domains(#{domains_attributes})").formats(CREATE_DOMAINS_FORMAT) do
    response = wait_for service, service.create_domains(domains_attributes)
    @domain_details = response.body['response']['domains']
    @domain_ids = @domain_details.collect { |domain| domain['id'] }
    response.body['response']
  end

  begin
    if block_given?
      yield
    end
  ensure
    if !custom_delete
      tests("remove_domains(#{@domain_ids})").succeeds do
        wait_for service, service.remove_domains(@domain_ids)
      end
    end
  end
end


