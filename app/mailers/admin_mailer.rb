class AdminMailer < ApplicationMailer
    default from: 'support@gmail.com'
  
    def offer_to_mail(admin)
        @admin = admin
        mail to: @admin.email , subject:"Contact Email"
    end
end