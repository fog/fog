module Fog
  module Storage
    class AWS

      private
        def self.hash_to_acl(acl)
          data =  "<AccessControlPolicy>\n"

          if acl['Owner'] && (acl['Owner']['ID'] || acl['Owner']['DisplayName'])
            data << "  <Owner>\n"
            data << "    <ID>#{acl['Owner']['ID']}</ID>\n" if acl['Owner']['ID']
            data << "    <DisplayName>#{acl['Owner']['DisplayName']}</DisplayName>\n" if acl['Owner']['DisplayName']
            data << "  </Owner>\n"
          end

          data << "  <AccessControlList>\n" if acl['AccessControlList'].any?
          acl['AccessControlList'].each do |grant|
            data << "    <Grant>\n"
            type = case grant['Grantee'].keys.sort
            when ['ID']
              'CanonicalUser'
            when ['EmailAddress']
              'AmazonCustomerByEmail'
            when ['URI']
              'Group'
            end

            data << "      <Grantee xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:type=\"#{type}\">\n"
            data << "        <ID>#{grant['Grantee']['ID']}</ID>\n" if grant['Grantee']['ID']
            data << "        <DisplayName>#{grant['Grantee']['DisplayName']}</DisplayName>\n" if grant['Grantee']['DisplayName']
            data << "        <EmailAddress>#{grant['Grantee']['EmailAddress']}</EmailAddress>\n" if grant['Grantee']['EmailAddress']
            data << "        <URI>#{grant['Grantee']['URI']}</URI>\n" if grant['Grantee']['URI']
            data << "      </Grantee>\n"
            data << "      <Permission>#{grant['Permission']}</Permission>\n"
            data << "    </Grant>\n"
          end
          data << "  </AccessControlList>\n" if acl['AccessControlList'].any?

          data << "</AccessControlPolicy>"

          data
        end

    end
  end
end
