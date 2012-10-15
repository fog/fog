require 'time'

module Fog
  class Logger

    @channels = {
        :deprecation  => ::STDOUT,
        :debug         => ::STDOUT,
        :warning       => ::STDOUT
    }

    @log_level = "warn"
    @open_or_not = true
    @formatter = Proc.new do |header, msg|
      "#{header}[#{Time.now.rfc2822}]#{msg}"
    end

    def self.[](channel)
      @channels[channel]
    end

    def self.[]=(channel, value)
      @channels[channel] = value
    end

    def self.open
      @open_or_not = true
    end

    def self.close
      @open_or_not = false
    end

    def self.set_log_level(user_log_level)
      @log_level= user_log_level
    end

    def self.deprecation(message)
      return unless @open_or_not
      if (@log_level == "info") || (@log_level == "debug") || (@log_level == "warn")
        self.write(:deprecation, "#{@formatter.call("[yellow][DEPRECATION]", message)}[/]\n")
      end
    end

    def self.debug(message)
      return unless @open_or_not
      if (@log_level == "debug") || (@log_level == "warn")
        self.write(:debug, "#{@formatter.call("[light_black][DEBUG]", message)}[/]\n")
      end
    end

    def self.warning(message)
      return unless @open_or_not
      if (@log_level == "warn")
        self.write(:warning, "#{@formatter.call("[yellow][WARNING]", message)}[/]\n")
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
