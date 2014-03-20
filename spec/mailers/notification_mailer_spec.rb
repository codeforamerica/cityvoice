require "spec_helper"

describe NotificationMailer do
  let(:property) { create(:property, name: '1313 mockingbird lane') }
  let!(:notification_subscription) { property.notification_subscriptions.create!(email: 'tacos@example.com') }

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
  end

  describe '#weekly_activity2' do
    let(:properties) { [{property: property, feedback_inputs: [], unsubscribe_token: 'i-like-geese'}] }
    let(:mail) { NotificationMailer.weekly_activity2('user@example.com', properties) }

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
      mail.body.encoded.should =~ /localhost:3000#{property.url_to}/
    end

    it 'assigns @unsubscribe_all_token' do
      mail.body.encoded.should include('i-like-geese')
    end
  end
end
