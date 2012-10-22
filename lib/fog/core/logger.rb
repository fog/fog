require 'time'

module Fog
  class Logger

    @channels = {
        :deprecation  => ::STDOUT,
        :debug         => ::STDOUT,
        :warning       => ::STDOUT
    }

    @log_level = "warn"
    @formatter = Proc.new do |header, msg|
      "[#{Time.now.rfc2822}] #{header} #{msg}"
    end

    def self.[](channel)
      @channels[channel]
    end

    def self.[]=(channel, value)
      @channels[channel] = value
    end

    def self.set_log_level(user_log_level)
      @log_level= user_log_level
    end

    def self.debug(message)
      if (@log_level == "debug")
        self.write(:debug, "#{@formatter.call("[light_black]DEBUG:", message)}[/]\n")
      end
    end

    def self.deprecation(message)
      if (@log_level == "debug") || (@log_level == "info")
        self.write(:deprecation, "#{@formatter.call("[yellow]INFO:", message)}[/]\n")
      end
    end

    def self.warning(message)
      if (@log_level == "debug") || (@log_level == "info") || (@log_level == "warn")
        self.write(:warning, "#{@formatter.call("[yellow]WARN:", message)}[/]\n")
      end
    end

    def self.write(key, value)
      if channel = @channels[key]
        value.gsub(Formatador::INDENT_REGEX, '')
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
