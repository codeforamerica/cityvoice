class AppContentSet < Struct.new(:content_hash)
  def self.load!(path)
    content_hash = AppContentSetImporter.load!(path)
    new(content_hash)
  end

  def feedback_form_url
    content_hash[:feedback_form_url]
  end

  def header_color
    content_hash[:header_color]
  end

  def message_from
    content_hash[:message_from]
  end

  def message_url
    content_hash[:message_url]
  end

  def issue
    content_hash[:issue]
  end

  def short_title
    content_hash[:short_title]
  end

  def call_in_code_digits
    content_hash[:call_in_code_digits].to_i
  end

  def app_phone_number
    content_hash[:app_phone_number]
  end

  def call_text
    call_renderer.rendered
  end

  def learn_text
    learn_renderer.rendered
  end

  def listen_text
    listen_renderer.rendered
  end

  protected

  def call_renderer
    @call_renderer ||= AppContentRenderer.renderer_for(:call)
  end

  def learn_renderer
    @learn_renderer ||= AppContentRenderer.renderer_for(:learn)
  end

  def listen_renderer
    @listen_renderer ||= AppContentRenderer.renderer_for(:listen)
  end
end
