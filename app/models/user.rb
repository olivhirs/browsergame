class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  
  validates :name, presence: true, 
                   length: { maximum: 30 },
                   uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.update_attribute(:password_reset_token, self.password_reset_token)
    self.update_attribute(:password_reset_sent_at, Time.zone.now)
    UserMailer.password_reset(self).deliver
  end
  
  def send_email_confirmation
    generate_token(:email_confirmation_token)
    self.update_attribute(:email_confirmation_token, self.email_confirmation_token)
    self.update_attribute(:email_confirmation, false)
    UserMailer.email_confirmation(self).deliver
  end
  
  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
    
    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end
end
