module Fog
  module Compute
    class Cloudstack

      class Real
        # Enables static nat for given ip address
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/enableStaticNat.html]
        def enable_static_nat(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'enableStaticNat') 
          else
            options.merge!('command' => 'enableStaticNat', 
            'ipaddressid' => args[0], 
            'virtualmachineid' => args[1])
          end
          request(options)
        end
      end

      class Mock
        def enable_static_nat(*args)
          ip_address_id = nil
          virtual_machine_id = nil
          if args[0].is_a? Hash
            ip_address_id = args[0]['ipaddressid']
            virtual_machine_id = args[0]['virtualmachineid']
          else
            ip_address_id = args[0]
            virtual_machine_id = args[1]
          end

          server = self.data[:servers][virtual_machine_id]
          address = self.data[:public_ip_addresses][ip_address_id]

          unless server
            raise Fog::Compute::Cloudstack::BadRequest.new(
"Unable to execute API command enablestaticnat due to invalid value. \
Invalid parameter virtualmachineid value=#{virtual_machine_id} due to incorrect long value format, \
or entity does not exist or due to incorrect parameter annotation for the field in api cmd class.")
          end

          unless address
            raise Fog::Compute::Cloudstack::BadRequest.new(
"Unable to execute API command enablestaticnat due to invalid value. \
Invalid parameter ipaddressid value=#{ip_address_id} due to incorrect long value format, \
or entity does not exist or due to incorrect parameter annotation for the field in api cmd class.")
          end

          unless address['virtualmachineid'].nil?
            raise Fog::Compute::Cloudstack::BadRequest.new(
"Failed to enable static nat for the ip address id=#{ip_address_id} \
as vm id=#{virtual_machine_id} is already associated with ip id=#{ip_address_id}")
          end

          address.merge!(
            'virtualmachineid'          => server['id'],
            'virtualmachinname'         => server['name'],
            'virtualmachinedisplayname' => server['displayname']
          )
          {'enablestaticnatresponse' => {'success' => 'true'}}
        end
      end
    end
  end
end

