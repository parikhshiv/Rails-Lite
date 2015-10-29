require 'uri'
require 'byebug'

module Phase5
  class Params
    def initialize(req, route_params = {})
      @params = route_params

      parse_www_encoded_form(req.query_string) if req.query_string
      parse_www_encoded_form(req.body) if req.body
    end

    def [](key)
      @params[key.to_s] || @params[key.to_sym]
    end

    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private

    def parse_www_encoded_form(www_encoded_form)
      query_array = URI::decode_www_form(www_encoded_form)
      query_array.each do |arr|
        current = @params
        keys = parse_key(arr[0])
        keys[0...-1].each do |key|
          current[key] ||= {}
          current = current[key]
        end
        current[keys.last] = arr[1]
      end
    end

    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
