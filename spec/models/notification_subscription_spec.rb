require 'spec_helper'

describe NotificationSubscription do
  let(:property) { create(:property) }

  it { should belong_to(:property) }
  it { should allow_value('user@example.com', 'us.er@example.com', 'user+plus@example.com').for(:email) }
  it { should_not allow_value('wat').for(:email) }

  it 'validates the uniqueness of the email' do
    property.notification_subscriptions.create!(email: 'tacos@example.com')

    expect {
      property.notification_subscriptions.create!(email: 'tacos@example.com')
    }.to raise_error
  end

  describe '#confirm!' do
    subject(:notification_subscription) { property.notification_subscriptions.create!(email: 'wat@example.com') }

    it 'sets the confirmed flag' do
      expect { notification_subscription.confirm! }.to change { notification_subscription.reload.confirmed }.to(true)
    end
  end

  describe '#confirmed?' do
    subject(:notification_subscription) { property.notification_subscriptions.create!(email: 'wat@example.com') }

    context 'when the notification subscription has not been confirmed' do
      it { should_not be_confirmed }
    end

    context 'when the notification subscription has been confirmed' do
      before { notification_subscription.confirm! }

      it { should be_confirmed }
    end
  end

  describe '#confirmation_sent?' do
    subject(:notification_subscription) { property.notification_subscriptions.build(email: 'wat@example.com') }

    context 'when the notification subscription has not been saved' do
      it { should_not be_confirmation_sent }
    end

    context 'when the notification subscription has been saved' do
      before { notification_subscription.save! }

      it { should be_confirmation_sent }
    end
  end

  describe '#override_last_email_sent_at_to!' do
    subject(:notification_subscription) { property.notification_subscriptions.create!(email: 'wat@example.com') }
    let(:last_sent) { Time.parse('December 30, 1981') }

    it 'sets the last email sent at field' do
      expect {
        notification_subscription.override_last_email_sent_at_to!(last_sent)
      }.to change { notification_subscription.last_email_sent_at }.to(last_sent)
    end
  end
end
