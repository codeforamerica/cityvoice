class AddFeedbackFormUrlToAppContentSet < ActiveRecord::Migration
  def change
    add_column :app_content_sets, :feedback_form_url, :string
  end
end
