# Rails Lite

### Rails built from scratch...cool!

Uses hash to parse nested keys from from params in url:

```
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
```
