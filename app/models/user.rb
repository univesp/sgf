class User < ApplicationRecord
  
  has_one :identity, :dependent => :destroy

  TEMP_EMAIL_REGEX = /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/

  devise :database_authenticatable, :registerable, :confirmable, :recoverable, 
         :rememberable, :trackable, :validatable, :omniauthable

  validates :name, presence: true
  validates :email, presence: true
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  
  def self.find_for_oauth(auth, signed_in_resource = nil)

    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user
    if user.nil?
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          email: auth.extra.raw_info.email,
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  private

  def get_uid
    email.split('@')[0]
  end

  def update_info
    unless email.blank?
      self.email = email.downcase 
    end
  end

  def log(message=nil)
    @log ||= Logger.new("#{Rails.root}/log/user_and_student_enrol.log")
    @log.debug(message) unless message.nil?
  end
end
