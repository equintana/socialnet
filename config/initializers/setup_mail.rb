ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "socialnet.com",
  :user_name            => "ricardo.berdejo@koombea.com",
  :password             => "b3rde!0M",
  :authentication       => "plain",
  :enable_starttls_auto => true
}