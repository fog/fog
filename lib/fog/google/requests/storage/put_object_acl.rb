module Fog
  module Storage
    class Google
      class Real
        # TODO: move this methods to helper to use them with put_bucket_acl request
        def tag(name, value)
          "<#{name}>#{value}</#{name}>"
        end

        def scope_tag(scope)
          if %w(AllUsers AllAuthenticatedUsers).include?(scope['type'])
            "<Scope type='#{scope['type']}'/>"
          else
            "<Scope type='#{scope['type']}'>" +
              scope.to_a.select {|pair| pair[0] != 'type'}.map { |pair| tag(pair[0], pair[1]) }.join("\n") +
            "</Scope>"
          end
        end

        def entries_list(access_control_list)
          access_control_list.map do |entry|
            tag('Entry', scope_tag(entry['Scope']) + tag('Permission', entry['Permission']))
          end.join("\n")
        end

        def put_object_acl(bucket_name, object_name, acl)
          data = <<-DATA
<AccessControlList>
  <Owner>
    #{tag('ID', acl['Owner']['ID'])}
  </Owner>
  <Entries>
    #{entries_list(acl['AccessControlList'])}
  </Entries>
</AccessControlList>
DATA

          request({
            :body     => data,
            :expects  => 200,
            :headers  => {},
            :host     => "#{bucket_name}.#{@host}",
            :method   => 'PUT',
            :query    => {'acl' => nil},
            :path     => CGI.escape(object_name)
          })
        end
      end
    end
  end
end
