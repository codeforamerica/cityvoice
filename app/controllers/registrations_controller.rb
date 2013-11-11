class RegistrationsController < Devise::RegistrationsController
  # Only want edit, update and destroy actions for admin
  # to manage their account. Admin users can be created via
  # the console or db seeding.
  before_action :render_not_found, only: [:new, :create]
end
