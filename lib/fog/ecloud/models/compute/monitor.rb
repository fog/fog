module Fog
  module Compute
    class Ecloud
      class Monitor < Fog::Ecloud::Model
        identity :href

        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :interval, :aliases => :Interval, :type => :integer
        attribute :response_timeout, :aliases => :ResponseTimeout, :type => :integer
        attribute :retries, :aliases => :Retries, :type => :integer
        attribute :downtime, :aliases => :Downtime, :type => :integer
        attribute :enabled, :aliases => :Enabled, :type => :boolean
        attribute :request_uri, :aliases => :RequestUri
        attribute :http_headers, :aliases => :HttpHeaders
        attribute :response_codes, :aliases => :ResponseCodes
        attribute :send_string, :aliases => :SendString
        attribute :receive_string, :aliases => :ReceiveString

        def edit(options = {})
          href = "#{service.base_path}/internetServices/#{internet_service_id}/monitor?type="
          case type
          when "application/vnd.tmrk.cloud.pingMonitor"
            options[:uri] = href + "ping"
            data = service.monitors_edit_ping(options).body
          when "application/vnd.tmrk.cloud.httpMonitor"
            options[:uri] = href + "http"
            data = service.monitors_edit_http(options).body
          when "application/vnd.tmrk.cloud.ecvMonitor"
            options[:uri] = href + "ecv"
            data = service.monitors_edit_ecv(options).body
          end
          object = collection.from_data(data)
        end

        def internet_service_id
          other_links[:Link][:href].scan(/\d+/)[0]
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
