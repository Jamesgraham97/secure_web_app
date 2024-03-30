class User < ApplicationRecord
    has_secure_password
    has_many :messages
    
    # Validations
    validates :username, presence: true, uniqueness: true, length: { minimum: 4, maximum: 30 }
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    
    # Callbacks
    before_save :downcase_email
  
    private
  
    # Downcase email before saving to avoid case-sensitive unique constraint issues
    def downcase_email
      self.email = email.downcase
    end
  end
  