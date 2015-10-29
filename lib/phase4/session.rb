require 'json'
require 'webrick'

module Phase4
  class Session
    def initialize(req)
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app'
          @hash = JSON.parse(cookie.value)
        end
      end
      @hash ||= {}
    end

    def [](key)
      @hash[key]
    end

    def []=(key, val)
      @hash[key] = val
    end

    def store_session(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_app', @hash.to_json)
    end
  end

  class Flash
    def initialize(req)
      req.cookies.each do |cookie|
        if cookie.name == 'flash'
          @old1 = JSON.parse(cookie.value)
        end
      end
      @old1 ||= {}
      @old = {}
      @old1.each {|key, v| @old[key.to_sym] = v}
      @new_hash = {}
    end

    def [](key)
      p 'yes'
      @old[key]
    end

    def []=(key, val)
      @new_hash[key] = val
    end

    def now
      @new_hash
    end

    def store_flash(res)
      p 'old'
      p @old
      res.cookies << WEBrick::Cookie.new('flash', @old.to_json)
    end

    def store_flash_now(res)
      p 'new'
      p @new_hash
      res.cookies << WEBrick::Cookie.new('flash', @new_hash.to_json)
    end
  end
end
