module Phase2
  class ControllerBase
    attr_reader :req, :res

    def initialize(req, res)
      @req, @res = req, res
    end

    def already_built_response?
      @already_built_response
    end

    def redirect_to(url)
      raise "Exception" if already_built_response?
      @res.status = 302
      @res["Location"] = url
      @already_built_response = true
    end


    def render_content(content, content_type)
      raise "Exception" if already_built_response?
      @res.body = content
      @res.content_type = content_type
      @already_built_response = true
    end
  end
end
