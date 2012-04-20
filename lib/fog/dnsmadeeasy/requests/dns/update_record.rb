module Fog
  module DNS
    class DNSMadeEasy
      class Real

        # Updates a record with the representation specified in the request content. Returns errors if record is not valid.
        # Note that a record ID will be generated by the system with this request and any ID that is sent will be ignored. Records are not modifiable for domains that are locked to a template.
        #
        # DNS Made Easy has no update record method but they plan to add it in the next update!
        # They sent a reponse suggesting, there going to internaly delete/create a new record when we make update record call, so I've done the same here for now!
        # If want to update a record, it might be better to manually destroy and then create a new record
        #
        # ==== Parameters
        # * domain<~String> Domain name.
        # * record_id<~Integer> Record id.
        # * options<~Hash>
        #   * name<~String> Record name.
        #   * type<~String> Record type. Values: A, AAAA, CNAME, HTTPRED, MX, NS, PTR, SRV, TXT
        #   * ttl<~Integer> Time to live. The amount of time a record will be cached before being refreshed. Default: 1800 (30 mins)
        #   * gtdLocation<~String> Global Traffic Director location. Values: DEFAULT, US_EAST, US_WEST, EUROPE
        #   * password<~String> For A records. Password used to authenticate for dynamic DNS.
        #   * description<~String> For HTTPRED records. A description of the HTTPRED record.
        #   * keywords<~String> For HTTPRED records. Keywords associated with the HTTPRED record.
        #   * title<~String> For HTTPRED records. The title of the HTTPRED record.
        #   * redirectType<~String> For HTTPRED records. Type of redirection performed. Values: Hidden Frame Masked, Standard - 302, Standard - 301
        #   * hardLink<~Boolean> For HTTPRED records.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * id<~Integer> Unique record identifier
        #     * name<~String>
        #     * type<~String>
        #     * data<~String>
        #     * ttl<~Integer>
        #     * gtdLocation<~String>
        #     * password<~String>
        #     * description<~String>
        #     * keywords<~String>
        #     * title<~String>
        #     * redirectType<~String>
        #     * hardLink<~Boolean>
        #   * 'status'<~Integer> - 201 - record successfully created, 400 - record not valid, see errors in response content, 404 - domain not found
        def update_record(domain, record_id, options = {})
          request(
            :expects  => 200,
            :method   => "PUT",
            :path     => "/V1.2/domains/#{domain}/records/#{record_id}",
            :body     => MultiJson.dump(options)
          )
        end

      end
    end
  end
end
