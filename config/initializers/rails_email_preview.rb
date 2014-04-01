if defined?(RailsEmailPreview)
  Rails.application.config.to_prepare do
    RailsEmailPreview.preview_classes = Dir[Rails.root.join 'app/mailer_previews/*_preview.rb'].map do |p|
      File.basename(p, '.rb').camelize
    end
  end
end
