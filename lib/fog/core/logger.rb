module Fog
  class Logger

    @channels = {
      :deprecation  => ::STDOUT,
      :warning      => ::STDOUT
    }

    @channels[:debug] = ::STDOUT if ENV['DEBUG']

    def self.[](channel)
      @channels[channel]
    end

    def self.[]=(channel, value)
      @channels[channel] = value
    end

    def self.debug(message)
      self.write(:debug, "[light_black][fog][DEBUG] #{message}[/]\n")
    end

    def self.deprecation(message)
      self.write(:deprecation, "[yellow][fog][DEPRECATION] #{message}[/]\n")
    end

    def self.warning(message)
      self.write(:warning, "[yellow][fog][WARNING] #{message}[/]\n")
    end

    def self.write(key, value)
      if channel = @channels[key]
        message = if channel.tty?
          value.gsub(Formatador::PARSE_REGEX) { "\e[#{Formatador::STYLES[$1.to_sym]}m" }.gsub(Formatador::INDENT_REGEX, '')
        else
          value.gsub(Formatador::PARSE_REGEX, '').gsub(Formatador::INDENT_REGEX, '')
        end
        channel.write(message)
      end
      nil
    end

  end
end
