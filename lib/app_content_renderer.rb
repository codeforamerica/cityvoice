class AppContentRenderer < Struct.new(:path, :memoize)
  def self.renderer_for(content_type)
    new(Rails.root.join('data', "#{content_type}.md"), Rails.env.production?)
  end

  def rendered
    if memoize
      @rendered ||= markdown.render(content).html_safe
    else
      markdown.render(content).html_safe
    end
  end

  protected

  def content
    File.read(path)
  end

  def markdown
    @markdown ||= Redcarpet::Markdown.new(renderer)
  end

  def renderer
    @renderer ||= Redcarpet::Render::HTML.new(tables: true, autolink: true)
  end
end
