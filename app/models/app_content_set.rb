class AppContentSet < Struct.new(:content_hash)
  extend Forwardable

  def self.load!(path)
    content_hash = AppContentSetImporter.load!(path)
    new(content_hash)
  end

  def_delegators :content, :app_phone_number,
                           :feedback_form_url,
                           :header_color,
                           :issue,
                           :message_from,
                           :message_url,
                           :short_title

  def call_in_code_digits
    content_hash[:call_in_code_digits].to_i
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

  def content
    @content ||= OpenStruct.new(content_hash)
  end

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
