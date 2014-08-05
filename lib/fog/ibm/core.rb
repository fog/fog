require 'fog/core'
require 'fog/json'

module Fog
  module IBM
    extend Fog::Provider

    service(:compute, 'Compute')
    service(:storage, 'Storage')

    # Provisioning is very slow. We'll pass this arg explicitly until there's a way
    # to set the default timeout on a per-provider basis.

    def self.timeout
      1800
    end

    class Connection < Fog::XML::Connection
      def initialize(user, password)
        @user = user
        @password = password
        @endpoint = URI.parse('https://www-147.ibm.com/computecloud/enterprise/api/rest/20100331')
        @base_path = @endpoint.path
        super("#{@endpoint.scheme}://#{@endpoint.host}:#{@endpoint.port}")
      end

      def request(options)
        options[:path] = @base_path + options[:path]
        options[:headers] ||= {}
        options[:headers]['Authorization'] = auth_header
        options[:headers]['Accept'] = 'application/json'
        options[:headers]['Accept-Encoding'] = 'gzip'
        unless options[:body].nil?
          options[:headers]['Content-Type'] = 'application/x-www-form-urlencoded'
          options[:body] = form_encode(options[:body])
        end
        response = super(options)
        unless response.body.empty?
          response.body = Fog::JSON.decode(response.body)
        end
        response
      end

      def auth_header
        @auth_header ||= 'Basic ' + Base64.encode64("#{@user}:#{@password}").gsub("\n",'')
      end

      def form_encode(params)
        params.reject {|k, v| v.nil? }.map {|pair| pair.map {|x| URI.escape(x.to_s) }.join('=') }.join('&')
      end
    end

    class Mock
      class << self
        def id
          Fog::Mock.random_numbers(7).to_i.to_s
        end
        alias_method :instance_id, :id
        alias_method :request_id,  :id

        def primary_ip
          { "type" => 0, "ip" => Fog::IBM::Mock.ip_address, "hostname" => Fog::IBM::Mock.hostname }
        end

        def ip_address
          ip = []
          4.times do
            ip << Fog::Mock.random_numbers(rand(3) + 1).to_i.to_s # remove leading 0
          end
          ip.join('.')
        end

        def hostname
          "vhost" + Fog::Mock.random_numbers(3).to_i.to_s + ".fake.compute.ihost.com"
        end

        # Miliseconds since epoch
        def launch_time
          (Time.now.tv_sec * 1000).to_i
        end

        # 1 year from now, in miliseconds since epoch
        def expiry_time
          ((Time.now.tv_sec + 31556926) * 1000).to_i
        end

        def owner
          "user" + Fog::Mock.random_numbers(3).to_i.to_s + "@company.com"
        end

        def key_material
          OpenSSL::PKey::RSA.generate(1024)
        end

        def private_image(name, description)
          {
            "name"        => name,
            "createdTime" => Fog::IBM::Mock.launch_time,
            "productCodes"=> [],
            "id"          => Fog::IBM::Mock.instance_id,
            "description" => description,
            "visibility"  => "PRIVATE",
            "state"       => 0
          }
        end

        def create_instance(name, image_id, instance_type, location, options)
          {
            "name"          => name,
            "location"      => location,
            "keyName"       => options[:key_name],
            "primaryIP"     => Fog::IBM::Mock.primary_ip,
            "productCodes"  => [],
            "requestId"     => Fog::IBM::Mock.request_id,
            "imageId"       => image_id,
            "launchTime"    => Fog::IBM::Mock.launch_time,
            "id"            => Fog::IBM::Mock.instance_id,
            "volumes"       => [],
            "isMiniEphemeral" => "false",
            "instanceType"  => instance_type,
            "diskSize"      => "60",
            "requestName"   => "",
            "secondaryIP"   => [],
            "status"        => 1,
            "software"      => [
              { "name"=>"SUSE Linux Enterprise Server",
                "type"=>"OS",
                "version"=>"11 SP1" }
            ],
            "expirationTime"=> Fog::IBM::Mock.expiry_time,
            "owner"         => Fog::IBM::Mock.owner
          }
        end

        def create_volume(name, format, location_id, size, offering_id)
          {
            "instanceId"  => "0",
            "state"       => 1,
            "size"        => size,
            "offeringId"  => offering_id,
            "ioPrice" => {
              "rate"  => 0.11,
              "unitOfMeasure" => "CNT",
              "countryCode"   => "897",
              "effectiveDate" => Fog::IBM::Mock.launch_time,
              "currencyCode"  => "USD",
              "pricePerQuantity"  => 1
            },
            "owner"       => Fog::IBM::Mock.owner,
            "createdTime" => Fog::IBM::Mock.launch_time,
            "location"    => location_id,
            "productCodes"=> [],
            "format"      => format,
            "name"        => name,
            "id"          => Fog::IBM::Mock.id,
          }
        end

        def create_address(location_id, offering_id, vlan_id)
          # TODO: Figure out vlan handling
          {
            "id"        => Fog::IBM::Mock.id,
            "location"  => location_id,
            "offeringId"=> offering_id,
            "ip"        => "",
            "state"     => 0
          }
        end
      end
    end
  end
end
