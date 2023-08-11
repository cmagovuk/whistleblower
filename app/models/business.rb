class Business < ApplicationRecord

    belongs_to :submission

    POSTCODE_REGEX = /\A([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9][A-Za-z]?))))\s?[0-9][A-Za-z]{2})\z/.freeze

    attribute :business_url, :string, default: "https://"
    
    validates :business_name, presence: true, length: {maximum: 255}
    validates :business_address, presence: true, length: {maximum: 255}
    validates :business_url, length: {maximum: 255}

    validates :business_postcode, length: { maximum: 10 }, format: { with: POSTCODE_REGEX }, allow_blank: false

    validate :validate_business_url

    def validate_business_url
      if !business_url.blank?
          if !(business_url =~ /\A#{URI::regexp(['http', 'https'])}\z/)
              errors.add(:business_url,:invalid)
          end
      end      
    end

end
