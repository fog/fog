require File.expand_path(File.join(File.dirname(__FILE__), '..', 'google'))
require 'fog/storage'

module Fog
  module Storage
    class Google < Fog::Service

      requires :google_storage_access_key_id, :google_storage_secret_access_key
      recognizes :host, :port, :scheme, :persistent

      model_path 'fog/google/models/storage'
      collection  :directories
      model       :directory
      collection  :files
      model       :file

      request_path 'fog/google/requests/storage'
      request :copy_object
      request :delete_bucket
      request :delete_object
      request :get_bucket
      request :get_bucket_acl
      request :get_object
      request :get_object_acl
      request :get_object_torrent
      request :get_object_http_url
      request :get_object_https_url
      request :get_object_url
      request :get_service
      request :head_object
      request :put_bucket
      request :put_bucket_acl
      request :put_object
      request :put_object_url

      module Utils


        def http_url(params, expires)
          "http://" << host_path_query(params, expires)
        end

        def https_url(params, expires)
          "https://" << host_path_query(params, expires)
        end

        def url(params, expires)
          Fog::Logger.warning("Fog::Storage::Google => #url is deprecated, use #https_url instead [light_black](#{caller.first})[/]")
          https_url(params, expires)
        end

        private

        def host_path_query(params, expires)
          params[:headers]['Date'] = expires.to_i
          params[:path] = CGI.escape(params[:path]).gsub('%2F', '/')
          query = [params[:query]].compact
          query << "GoogleAccessKeyId=#{@google_storage_access_key_id}"
          query << "Signature=#{CGI.escape(signature(params))}"
          query << "Expires=#{params[:headers]['Date']}"
          "#{params[:host]}/#{params[:path]}?#{query.join('&')}"
        end

      end

      class Mock
        include Utils

        def self.acls(type)
          case type
          when 'private'
            {
              "AccessControlList"=> [
                {
                  "Permission" => "FULL_CONTROL",
                  "Scope" => {"ID" => "2744ccd10c7533bd736ad890f9dd5cab2adb27b07d500b9493f29cdc420cb2e0", "type" => "UserById"}
                }
              ],
              "Owner" => {"ID" => "2744ccd10c7533bd736ad890f9dd5cab2adb27b07d500b9493f29cdc420cb2e0"}
            }
          when 'public-read'
            {
              "AccessControlList"=> [
                {
                  "Permission" => "FULL_CONTROL",
                  "Scope" => {"ID" => "2744ccd10c7533bd736ad890f9dd5cab2adb27b07d500b9493f29cdc420cb2e0", "type" => "UserById"}
                },
                {
                  "Permission" => "READ",
                  "Scope" => {"type" => "AllUsers"}
                }
              ],
              "Owner" => {"ID" => "2744ccd10c7533bd736ad890f9dd5cab2adb27b07d500b9493f29cdc420cb2e0"}
            }
          when 'public-read-write'
            {
              "AccessControlList"=> [
                {
                  "Permission" => "FULL_CONTROL",
                  "Scope" => {"ID" => "2744ccd10c7533bd736ad890f9dd5cab2adb27b07d500b9493f29cdc420cb2e0", "type" => "UserById"}
                },
                {
                  "Permission" => "READ",
                  "Scope" => {"type" => "AllUsers"}
                },
                {
                  "Permission" => "WRITE",
                  "Scope" => {"type" => "AllUsers"}
                }
              ],
              "Owner" => {"ID" => "2744ccd10c7533bd736ad890f9dd5cab2adb27b07d500b9493f29cdc420cb2e0"}
            }
          when 'authenticated-read'
            {
              "AccessControlList"=> [
                {
                  "Permission" => "FULL_CONTROL",
                  "Scope" => {"ID" => "2744ccd10c7533bd736ad890f9dd5cab2adb27b07d500b9493f29cdc420cb2e0", "type" => "UserById"}
                },
                {
                  "Permission" => "READ",
                  "Scope" => {"type" => "AllAuthenticatedUsers"}
                }
              ],
              "Owner" => {"ID" => "2744ccd10c7533bd736ad890f9dd5cab2adb27b07d500b9493f29cdc420cb2e0"}
            }
          end
        end

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :acls => {
                :bucket => {},
                :object => {}
              },
              :buckets => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          require 'mime/types'
          @google_storage_access_key_id = options[:google_storage_access_key_id]
        end

        def data
          self.class.data[@google_storage_access_key_id]
        end

        def reset_data
          self.class.data.delete(@google_storage_access_key_id)
        end

        def signature(params)
          "foo"
        end

      end

    
      class Real
        include Utils

        # Initialize connection to Google Storage
        #
        # ==== Notes
        # options parameter must include values for :google_storage_access_key_id and
        # :google_storage_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   google_storage = Storage.new(
        #     :google_storage_access_key_id => your_google_storage_access_key_id,
        #     :google_storage_secret_access_key => your_google_storage_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #
        # ==== Returns
        # * Storage object with connection to google.
        def initialize(options={})
          require 'fog/core/parser'
          require 'mime/types'

          @google_storage_access_key_id = options[:google_storage_access_key_id]
          @google_storage_secret_access_key = options[:google_storage_secret_access_key]
          @connection_options = options[:connection_options] || {}
          @hmac = Fog::HMAC.new('sha1', @google_storage_secret_access_key)
          @host = options[:host] || 'commondatastorage.googleapis.com'
          @persistent = options[:persistent]  || true
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def signature(params)
          string_to_sign =
<<-DATA
#{params[:method]}
#{params[:headers]['Content-MD5']}
#{params[:headers]['Content-Type']}
#{params[:headers]['Date']}
DATA

          google_headers, canonical_google_headers = {}, ''
          for key, value in params[:headers]
            if key[0..6] == 'x-goog-'
              google_headers[key] = value
            end
          end

          google_headers = google_headers.sort {|x, y| x[0] <=> y[0]}
          for key, value in google_headers
            canonical_google_headers << "#{key}:#{value}\n"
          end
          string_to_sign << "#{canonical_google_headers}"

          subdomain = params[:host].split(".#{@host}").first
          unless subdomain =~ /^(?:[a-z]|\d(?!\d{0,2}(?:\.\d{1,3}){3}$))(?:[a-z0-9]|\.(?![\.\-])|\-(?![\.])){1,61}[a-z0-9]$/
            Fog::Logger.warning("fog: the specified google storage bucket name(#{subdomain}) is not a valid dns name.  See: http://code.google.com/apis/storage/docs/developer-guide.html#naming")
            params[:host] = params[:host].split("#{subdomain}.")[-1]
            if params[:path]
              params[:path] = "#{subdomain}/#{params[:path]}"
            else
              params[:path] = "#{subdomain}"
            end
            subdomain = nil
          end

          canonical_resource  = "/"
          unless subdomain.nil? || subdomain == @host
            canonical_resource << "#{CGI.escape(subdomain).downcase}/"
          end
          canonical_resource << "#{params[:path]}"
          canonical_resource << '?'
          for key in (params[:query] || {}).keys
            if ['acl', 'location', 'logging', 'requestPayment', 'torrent', 'versions', 'versioning'].include?(key)
              canonical_resource << "#{key}&"
            end
          end
          canonical_resource.chop!
          string_to_sign << "#{canonical_resource}"

          signed_string = @hmac.sign(string_to_sign)
          signature = Base64.encode64(signed_string).chomp!
        end


        private

        def request(params, &block)
          params[:headers]['Date'] = Fog::Time.now.to_date_header
          params[:headers]['Authorization'] = "GOOG1 #{@google_storage_access_key_id}:#{signature(params)}"

          response = @connection.request(params, &block)

          response
        end
      end
    end
  end
end
