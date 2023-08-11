class Notifier

    require "notifications/client"
  
    def self.Send(submission)

      template_id = Rails.application.config.govuk_notify_templates.fetch(:submission)

      puts api_key
      puts template_id

      if api_key.present? and template_id.present? and submission.contact_email_address.present?
        notify_client.send_email(
          email_address: submission.contact_email_address,
          template_id: template_id,
          personalisation: {
            reference_number: submission.reference_number
          },
        )
      end

    rescue Notifications::Client::BadRequestError => e
      # silently ignore failure to send email
      Rails.logger.warn "Failed to send email #{e.message}"

    end
  
    private_class_method def self.notify_client
      @notify_client || Notifications::Client.new(api_key)
    end
  
    private_class_method def self.api_key
      @api_key || ENV["GOVUK_NOTIFY_API_KEY"]
    end

  end