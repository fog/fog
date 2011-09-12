require 'uri'
require 'cgi'


module Fog
  module Compute
    module LibvirtUtil

      class URI

        attr_reader :uri

        def initialize(uri)
          @parsed_uri=::URI.parse(uri)
          @uri=uri
          return self
        end

        # Transport will be part of the scheme
        # The part after the plus sign
        # f.i. qemu+ssh
        def transport
          scheme=@parsed_uri.scheme
          return nil if scheme.nil?

          return scheme.split(/\+/)[1]
        end

        def scheme
          return @parsed_uri.scheme
        end

        def driver
          scheme=@parsed_uri.scheme
          return nil if scheme.nil?

          return scheme.split(/\+/).first
        end

        def ssh_enabled?
          if remote?
            return transport.include?("ssh")
          else
            return false
          end
        end

        def remote?
          return !transport.nil?
        end

        def user
          @parsed_uri.user
        end

        def host
          @parsed_uri.host
        end

        def port
          @parsed_uri.port
        end

        def password
          @parsed_uri.password
        end

        def name
          value("name")
        end

        def command
          value("command")
        end

        def socket
          value("socket")
        end

        def keyfile
          value("command")
        end

        def netcat
          value("netcat")
        end

        def no_verify?
          no_verify=value("no_verify")
          return false if no_verify.nil?

          if no_verify.to_s=="0"
            return false
          else
            return true
          end
        end

        def verify?
          return !no_verify?
        end

        def no_tty?
          no_tty=value("no_tty")

          return false if no_tty.nil?

          if no_tty=="0"
            return false
          else
            return true
          end

        end

        def tty?
          return !no_tty?
        end

        def pkipath
          value("pkipath")
        end


        # A libvirt URI allows you to specify extra params
        # http://libvirt.org/remote.html
        private
        def value(name)
          params=CGI.parse(@parsed_uri.query)
          if params.has_key?(name)
            return params[name].first
          else
            return nil
          end
        end


      end
    end
  end
end

