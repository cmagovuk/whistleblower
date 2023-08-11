class Submission < ApplicationRecord

    has_many :businesses
    
    has_many_attached :evidence_files

    serialize :router, Router

    EMAIL_REGEX = /\A(?!\.)("([^"\r\\]|\\["\r\\])*"|([-a-zA-Z0-9!#$%&'*+\/=?^_`{|}~]|(?<!\.)\.)*)(?<!\.)@[a-zA-Z0-9][\w.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z.]*[a-zA-Z]\z/.freeze
  
    # validates :what_happened, presence: { if: ->(o) { o.status.to_sym == :what_happened }}, length: { maximum: 5000 }, allow_blank:false, on: :update

    validates :contact_name, presence: { if: ->(o) { o.status.to_sym == :contact }}, length: { maximum: 255 }, allow_blank:true, on: :update
    
    validates :contact_email_address, presence: { if: ->(o) { o.status.to_sym == :contact }}, length: { maximum: 255 }, allow_blank:true, format: { with: EMAIL_REGEX }, on: :update

    validates :contact_telephone_number, presence: { if: ->(o) { o.status.to_sym == :contact }}, length: { maximum: 20 }, allow_blank:true, format: { with: /\A(?:\+?|\b)[0-9 \-()]{5,}\b\z/ }, on: :update

    validate :validate_contact_email_address

    validate :validate_what_happened

    def validate_what_happened
      # the built in max length validates method counts carriage returns incorrectly
      if status.to_sym == :what_happened and what_happened.gsub("\r\n","\n").length > 5000
        errors.add(:what_happened,:too_long, count: 5000)
      end
    end

    def validate_contact_email_address
      if contact_email_address.blank? and include_contact == "yes"
        errors.add(:contact_email_address,:blank)
      end
    end

    INCLUDE_CONTACT_OPTIONS = %w[yes no].freeze

    CONTENT_TYPES_ALLOWED = %w[
      text/plain
      application/pdf
      image/jpeg
      image/png
      video/mp4
      video/quicktime
      video/x-ms-wmv
      application/msword
      application/vnd.ms-excel
      application/vnd.ms-powerpoint
      application/vnd.openxmlformats-officedocument.wordprocessingml.document
      application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
      application/vnd.openxmlformats-officedocument.presentationml.presentation
    ].freeze
  
    FILE_SIZE_LIMIT = 10.megabytes
    MAXIMUM_FILE_UPLOADS = 5
    
    def valid_file?(f)
      @valid_file ||= !too_many_files? && valid_file_size?(f) && valid_file_type?(f) && non_empty_file?(f) && file_unique?(f)
    end
  
    def self.Purge!(date)
      where(
        "submissions.created_at <= :date", date: date
      ).where(
        "submissions.updated_at <= :date", date: 45.minutes.ago
      ).destroy_all
    end

private
  
    def valid_file_size?(f)
      return true if f.size <= FILE_SIZE_LIMIT
  
      errors.add(
        :evidence_files,
        I18n.t(
          "errors.upload.file_size_error_message",
          filename: document.original_filename,
          size_limit: ActiveSupport::NumberHelper.number_to_human_size(FILE_SIZE_LIMIT),
        ),
      )
      false
    end
  
    def non_empty_file?(f)
      return true unless f.size.zero?
  
      errors.add(
        :evidence_files,
        I18n.t("errors.upload.empty_file_error_message"),
      )
      false
    end
  
    def too_many_files?
      return false unless evidence_files.count >= MAXIMUM_FILE_UPLOADS
  
      errors.add(:evidence_files, I18n.t("errors.upload.too_many_files_error_message", file_uploads: MAXIMUM_FILE_UPLOADS))
      true
    end
  
    def valid_file_type?(f)
      return true if CONTENT_TYPES_ALLOWED.include?(f.content_type)
      errors.add(:evidence_files, I18n.t("errors.upload.file_type_error_message", filename: f.original_filename))
      false
    end
  
    def file_unique?(f)
      files = evidence_files.select {|att| att.filename == f.original_filename}
      if files.length > 0
        errors.add(:evidence_files, I18n.t("errors.upload.file_unique_error_message", filename: f.original_filename))
        return false
      else
        return true
      end
    end

end
