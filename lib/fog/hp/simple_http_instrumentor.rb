module Excon
  class SimpleHttpInstrumentor
    class << self
      attr_accessor :events

      def instrument(name, params = {}, &block)
        params = params.dup
        if params.key?(:headers) && params[:headers].key?('Authorization')
          params[:headers] = params[:headers].dup
          params[:headers]['Authorization'] = REDACTED
        end
        if params.key?(:password)
          params[:password] = REDACTED
        end
        $stderr.puts("--- #{name} ---")
        if name.include?('.request')
          query = ''
          tmp_query = ''
          if params.key?(:query) && !params[:query].nil?
            params[:query].each do |key, value|
              tmp_query += "#{key}=#{value}&"
            end
            if !tmp_query.nil?
              query = "?#{tmp_query}"
              query.chomp!('&')
            end
          end
          $stderr.puts("#{params[:method]} #{params[:path]}#{query} HTTP/1.1" )
          $stderr.puts("User-Agent: #{params[:headers]['User-Agent']}")
          $stderr.puts("Host: #{params[:host]} Port: #{params[:port]}")
          $stderr.puts("Accept: #{params[:headers]['Accept']}")
          $stderr.puts("X-Auth-Token: #{params[:headers]['X-Auth-Token']}")
          $stderr.puts("Body: #{params[:body]}")
        elsif name.include?('.response')
          $stderr.puts("HTTP/1.1 #{params[:status]}")
          $stderr.puts("Content-Length: #{params[:headers]['Content-Length']}")
          $stderr.puts("Content-Type: #{params[:headers]['Content-Type']}")
          $stderr.puts("Date: #{params[:headers]['Date']}")
          params[:headers].each do |key, value|
            if !['Content-Length', 'Content-Type', 'Date'].include?(key)
              $stderr.puts("#{key}: #{value}")
            end
          end
          $stderr.puts("Date: #{params[:headers]['Date']}\n")
          $stderr.puts("Body: #{params[:body]}")
        elsif name.include?('.retry')
          $stderr.puts("#{params.inspect}")
        elsif name.include?('.error')
          $stderr.puts("#{params.inspect}")
        end

        if block_given?
          yield
        end
      end
    end
  end
end
