class TestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.test_mailer.test_email.subject
  #
  def test_email
    @greeting = "Hi"

    mail to: "cory.mathis@uniteus.com"
  end
end
