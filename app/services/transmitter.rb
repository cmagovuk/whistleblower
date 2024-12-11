class Transmitter

  require "faraday_middleware"

  URL_ENV = "MWR_TRANSMIT_API".freeze
  
  def self.BuildJSON(submission)
   
    businesses = []
    if submission.businesses.length > 0
      submission.businesses.each do |business|
        businesses.push({ business_name: business.business_name, business_address: business.business_address, business_postcode: business.business_postcode, business_url: business.business_url })
      end
    end

    evidence_files = []
    if submission.evidence_files.attached?
      submission.evidence_files.each do |ef|
        evidence_files.push({ key: ef.key, filename: ef.filename })
      end
    end

    body = {
      method: "Submission.Submit",
      payload: {
        submission: {
          id: submission.id,
          reference_number: submission.reference_number,
          work_for_the_business: submission.work_for_the_business,
          businesses: businesses,
          what_happened: submission.what_happened,
          evidence: evidence_files,
          include_contact: (submission.include_contact.downcase == "yes") ? true : false ,
          contact_name: submission.contact_name,
          contact_email_address: submission.contact_email_address,
          contact_telephone_number: submission.contact_telephone_number
        }
      }
    }.to_json

    return body

  end

  
  def self.Transmit(submission)

    response = nil

    if ENV.key?(URL_ENV)

      url = ENV.fetch(URL_ENV)

      conn = Faraday.new do |f|
        f.response :json # decode response body as JSON
      end

      response = conn.post(url, BuildJSON(submission), "Content-Type" => "application/json")
      if response.body["success"]
        response.body["data"]
      else
        Rails.logger.warn "API failed"
        Rails.logger.warn response.body["error"] if response.body["error"].present?
        nil
      end

    end

    return response

  end


    
end