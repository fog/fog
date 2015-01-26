require 'fog/cloudsigma/error'

module Fog
  module CloudSigma
    module CloudSigmaConnection
      module Real
        def auth_header(type = :basic)
          case type
            when :basic
              unless @username and @password
                raise ArgumentError, 'Username and password required for basic auth'
              end
              {'Authorization' => 'Basic ' << Base64.encode64("#{@username}:#{@password}").gsub("\n", '')}
            else
              unless @username and @password
                raise ArgumentError, 'Username and password required for basic auth'
              end
              {'Authorization' => 'Basic ' << Base64.encode64("#{@username}:#{@password}").gsub("\n", '')}
          end
        end

        def setup_connection(options)
          @persistent = options[:persistent] || false
          @connection_options = options[:connection_options] || {}
          @connection_options[:ssl_verify_peer] = false

          @auth_type = options[:cloudsigma_auth_type] || :basic

          @username = options[:cloudsigma_username]
          @password = options[:cloudsigma_password]

          @scheme = options[:cloudsigma_scheme] || 'https'
          @host = options[:cloudsigma_host] || 'lvs.cloudsigma.com'
          @port = options[:cloudsigma_port] || '443'
          @api_path_prefix = options[:cloudsigma_api_path_prefix] || 'api'
          @api_version = options[:cloudsigma_api_version] || '2.0'
          @path_prefix = "#{@api_path_prefix}/#{@api_version}/"

          @connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def request(params)
          params[:headers] = params.fetch(:headers, {}).merge(auth_header(@auth_type))
          params[:headers]['Content-Type'] = 'application/json; charset=utf-8'

          req_path = params[:path]
          params[:path] = "#{@path_prefix}#{req_path}"

          params[:body] = Fog::JSON.encode(params[:body]) if params[:body]

          begin
            response = @connection.request(params)
          rescue Excon::Errors::HTTPStatusError => e

            e.response.data[:body] = Fog::JSON.decode(e.response[:body]) unless e.response[:body].empty?
            err = Fog::CloudSigma::Errors.slurp_http_status_error(e)

            raise err
          end
          response.body = Fog::JSON.decode(response.body) unless response.body.empty?

          response
        end

        def list_request(path, override_params={})
          default_params = {:method => 'GET', :expects => 200, :query => {:limit => 0}}
          override_params[:path] = path
          params = default_params.merge(override_params)

          request(params)
        end

        def get_request(path, override_params={})
          default_params = {:method => 'GET', :expects => 200}
          override_params[:path] = path
          params = default_params.merge(override_params)

          request(params)
        end

        def delete_request(path, override_params={})
          default_params = {:method => 'DELETE', :expects => 204}
          override_params[:path] = path
          params = default_params.merge(override_params)

          request(params)
        end

        def create_request(path, data, override_params={})
          default_params = {:method => 'POST', :expects => [200, 201, 202]}

          override_params[:path] = path
          override_params[:body] = data
          params = default_params.merge(override_params)

          request(params)
        end

        def update_request(path, data, override_params={})
          default_params = {:method => 'PUT', :expects => [200, 202]}

          override_params[:path] = path
          override_params[:body] = data
          params = default_params.merge(override_params)

          request(params)
        end
      end

      module Mock
        def setup_connection(options)
          @username = options[:cloudsigma_username]
          @password = options[:cloudsigma_password]
        end

        def mock_get(obj_or_collection, status, key=nil)
          data = self.data[obj_or_collection]
          if key
            data = data[key]
            unless data
              raise Fog::CloudSigma::Errors::NotFound.new("Object with uuid #{key} does not exist", 'notexist')
            end
          end

          Excon::Response.new(:body => Fog::JSON.decode(Fog::JSON.encode(data)), :status => status)
        end

        def mock_list(collection, status)
          data_array = self.data[collection].values

          Excon::Response.new(:body => {'objects' => data_array}, :status => status)
        end

        def mock_update(data, obj_or_collection, status, key, &clean_before_update)
          data = Fog::JSON.decode(Fog::JSON.encode(data))
          if key
            unless self.data[obj_or_collection][key]
              raise Fog::CloudSigma::Errors::NotFound.new("Object with uuid #{key} does not exist", 'notexist')
            end
            if clean_before_update
              new_data = clean_before_update.call(self.data[obj_or_collection][key], data)
            else
              new_data = self.data[obj_or_collection][key].merge(data)
            end

            self.data[obj_or_collection][key] = new_data
          else
            if clean_before_update
              new_data = clean_before_update.call(self.data[obj_or_collection], data)
            else
              new_data = self.data[obj_or_collection].merge(data)
            end

            self.data[obj_or_collection] = new_data
          end

          Excon::Response.new(:body =>  Fog::JSON.decode(Fog::JSON.encode(new_data)), :status => status)
        end

        def mock_delete(collection, status, key)
          self.data[collection].delete(key)

          Excon::Response.new(:body => '', :status => status)
        end

        def mock_create(collection, status, data, key, defaults={}, &clean_before_store)
          data_with_defaults = data.merge(defaults) {|k, oldval, newval| oldval == nil ? newval: oldval}

          if clean_before_store
            cleaned_data = clean_before_store.call(data_with_defaults)
          else
            cleaned_data = data_with_defaults
          end

          # Encode and decode into JSON so that the result is the same as the one returned and parsed from the API
          final_data =  Fog::JSON.decode(Fog::JSON.encode(cleaned_data))

          self.data[collection][key] = final_data

          # dup so that stored data is different instance from response data
          response_data = final_data.dup

          response = Excon::Response.new
          response.body = {'objects' => [response_data]}
          response.status = status

          response
        end
      end
    end
  end
end
