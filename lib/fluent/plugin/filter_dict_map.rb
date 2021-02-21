require 'fluent/plugin/filter'
require 'json'

module Fluent::Plugin
  class DictMapFilter < Filter
    Fluent::Plugin.register_filter('dict_map', self)

    config_param :key_name, :string, :desc => 'The source key name'
    config_param :destination_key_name, :string, :default => nil, :desc => 'The destination key name for mapped result'
    config_param :default_value, :string, :default => nil, :desc => 'The value is used when incoming value is missing in the dictionary'
    config_param :dictionary, :hash, :default => nil, :desc => 'The json dictionary for value mapping'
    config_param :dictionary_path, :string, :default => nil, :desc => 'The path of dictionary file. File ext must be `json`'

    def configure(conf)
      super

      if !@dictionary and !@dictionary_path
        raise Fluent::ConfigError, "dictionary or dictionary_path parameter is required"
      end

      @dict = @dictionary ? @dictionary : load_dict(@dictionary_path)
      @target = @destination_key_name.nil? ? @key_name : @destination_key_name
    end

    def filter(tag, time, record)
      value = record[@key_name]
      return record unless value

      value = value.to_s

      if @dict.include?(value)
        record[@target] = @dict[value]
      elsif !@default_value.nil?
        record[@target] = @default_value
      end

      record
    end

    private

    def load_dict(dict_path)
      case
      when dict_path.end_with?(".json")
        require 'json'
        JSON.parse(File.read(dict_path))
      else
        raise Fluent::ConfigError, "Invalid file type. Supported type is only JSON: #{dict_path}"
      end
    end
  end
end
