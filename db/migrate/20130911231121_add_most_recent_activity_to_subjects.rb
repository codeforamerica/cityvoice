class AddMostRecentActivityToSubjects < ActiveRecord::Migration
  def change
    add_column :subjects, :most_recent_activity, :datetime
  end
end
