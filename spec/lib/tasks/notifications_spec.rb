require 'spec_helper'

describe 'notifications rake task' do
  before do
    Rake.application.rake_require 'tasks/notifications'
    Rake::Task.define_task(:environment)
  end

  describe 'notifications:send' do
    let(:location) { create(:location) }
    let!(:location_subscription) { create(:location_subscription, :bulk_added, location: location) }
    let!(:answer) { create(:answer, created_at: Time.now + 1.day, location: location) }

    before do
      Rake::Task['notifications:send'].reenable
    end

    def run_rake_task
      Rake.application.invoke_task('notifications:send')
    end

    it 'sends a single email' do
      expect {
        run_rake_task
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end
end
