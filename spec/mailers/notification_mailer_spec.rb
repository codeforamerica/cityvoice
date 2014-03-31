require 'spec_helper'

describe NotificationMailer do
  let(:location) { create(:location, name: '1313 mockingbird lane') }
  let(:subscriber) { create(:subscriber, email: 'tacos@example.com') }
  let!(:notification_subscription) { create(:notification_subscription, subscriber: subscriber, location: location) }

  describe '#confirmation_email' do
    subject(:mail) { NotificationMailer.confirmation_email(notification_subscription) }

    it 'renders the subject' do
      mail.subject.should == 'Confirm to get notifications'
    end

    it 'renders the receiver email' do
      mail.to.should == ['tacos@example.com']
    end

    it 'renders the sender email' do
      mail.from.should == ['notifications@cityvoiceapp.com']
    end

    it 'assigns @token' do
      mail.body.encoded.should include(notification_subscription.auth_token)
    end

    it 'assigns @property' do
      mail.body.encoded.should include('1313 mockingbird lane')
    end

    it 'sends an email' do
      expect { mail.deliver }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end

  describe '#weekly_activity' do
    let(:subscriber) { create(:subscriber, email: 'user@example.com') }
    let(:mail) { NotificationMailer.weekly_activity(subscriber) }

    let!(:notification_subscription) { create(:notification_subscription, subscriber: subscriber, location: location) }

    it 'renders the subject' do
      mail.subject.should == 'New Activity on CityVoice!'
    end

    it 'renders the receiver email' do
      mail.to.should == ['user@example.com']
    end

    it 'renders the sender email' do
      mail.from.should == ['notifications@cityvoiceapp.com']
    end

    it 'assigns @properties_array' do
      mail.body.encoded.should include('localhost:3000/locations/1313-mockingbird-lane')
    end

    it 'assigns @unsubscribe_all_token' do
      mail.body.encoded.should include(notification_subscription.auth_token)
    end
  end
end
