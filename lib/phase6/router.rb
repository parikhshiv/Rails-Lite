module Phase6
  class Route
    attr_reader :pattern, :http_method, :controller_class, :action_name

    def initialize(pattern, http_method, controller_class, action_name)
      @pattern, @http_method = pattern, http_method
      @controller_class, @action_name = controller_class, action_name
    end

    def matches?(req)
      req.request_method.downcase.to_sym == self.http_method &&
        req.path =~ pattern
    end

    def run(req, res)
      match_data = req.path.match(@pattern)
      route_params = {}
      match_data.names.each {|key| route_params[key] = match_data[key]}
      @controller_class.new(req, res, route_params).invoke_action(action_name)
    end
  end

  class Router
    attr_reader :routes

    def initialize
      @routes = []
    end

    def add_route(pattern, method, controller_class, action_name)
      @routes << Route.new(pattern, method, controller_class, action_name)
    end

    def draw(&proc)
      instance_eval(&proc)
    end

    [:get, :post, :put, :delete].each do |http_method|
      define_method(http_method) do |pattern, controller_class, action_name|
        add_route(pattern, http_method, controller_class, action_name)
      end
    end

    def match(req)
      @routes.each {|route| return route if route.matches?(req)}
      nil
    end

    def run(req, res)
      match(req) ? match(req).run(req, res) : res.status = 404
    end
  end
end
