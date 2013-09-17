class AppContentSet < ActiveRecord::Base
  def self.configure_contents
    raise "Error: more than one instance of app content!" if self.count > 1
    if AppContentSet.count == 1
      app_content = AppContentSet.first
    else
      app_content = AppContentSet.new
    end
    yield app_content
    app_content.save
    app_content
  end
end
