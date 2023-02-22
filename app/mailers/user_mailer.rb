class UserMailer < ApplicationMailer
  default from: 'notifications@supertonic.com'

  def share_project_email
    email = params[:newUserEmail]
    mail(to: email, subject: 'supertonicccc')
  end
end
