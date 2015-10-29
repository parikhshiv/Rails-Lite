require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    def render(template_name)
      file = File.read("views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
      render_content(ERB.new(file).result(binding), "text/html")
    end
  end
end
