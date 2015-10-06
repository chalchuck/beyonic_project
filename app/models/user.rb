# == Schema Information
#
# Table name: users
#
#  authentication_code      :string
#  confirmation_sent_at     :datetime
#  confirmation_token       :string
#  confirmed_at             :datetime
#  created_at               :datetime         not null
#  current_sign_in_at       :datetime
#  current_sign_in_ip       :inet
#  email                    :string           default(""), not null
#  encrypted_password       :string           default(""), not null
#  failed_attempts          :integer          default(0), not null
#  first_name               :string
#  id                       :integer          not null, primary key
#  last_name                :string
#  last_sign_in_at          :datetime
#  last_sign_in_ip          :inet
#  locked_at                :datetime
#  mobile_number            :string
#  mobile_verification_code :string
#  remember_created_at      :datetime
#  reset_password_sent_at   :datetime
#  reset_password_token     :string
#  sign_in_count            :integer          default(0), not null
#  unconfirmed_email        :string
#  unlock_token             :string
#  updated_at               :datetime         not null
#  username                 :string
#  verified_at              :datetime
#
# Indexes
#
#  index_users_on_authentication_code       (authentication_code) UNIQUE
#  index_users_on_confirmation_token        (confirmation_token) UNIQUE
#  index_users_on_email                     (email) UNIQUE
#  index_users_on_mobile_number             (mobile_number) UNIQUE
#  index_users_on_mobile_verification_code  (mobile_verification_code) UNIQUE
#  index_users_on_reset_password_token      (reset_password_token) UNIQUE
#  index_users_on_unlock_token              (unlock_token) UNIQUE
#  index_users_on_username                  (username) UNIQUE
#

class User < ActiveRecord::Base

	attr_accessor :full_name, :login, :verification_code, :twoway_code

  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  ##########VALIDATIONS##################################################################
  validates :full_name, presence: true
  validates :first_name, presence: true, length: {in: 1..55}
  validates :last_name, presence: true, length: {in: 1..55}
  validates :password, confirmation: false
  validates :mobile_number, length: {in: 10..14}, allow_blank: true
  validates :username, length: {in: 3..20},
  										 allow_blank: true,
  										 format: {with: /\A[A-Z0-9_]*\z/i, message: "Your username should have only letters and numbers"}
  
  ##########CALLBACKS####################################################################
  after_create :generate_mobile_verification_code

  def to_s
    try(:name) or try(:email)
  end

  def full_name=(dirty_name)
  	self[:first_name], *lname = *(dirty_name.split(" "))
  	self[:last_name] = lname*' '
  end

  def mobile_number=(unformated_number)
  	self[:mobile_number] = MobileNumberService.new(self).prepend_prefix(unformated_number)
  end

  def full_name
  	[first_name, last_name].compact.join(' ')
  end
  alias_method :name, :full_name


  def verified?
    mobile_number.present? and mobile_verification_code.blank? and verified_at.present?
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    
    return where(conditions).first unless (login = conditions.delete(:login))
    where(conditions).where(["lower(username) = :opt OR lower(email) = :opt", {opt: login.downcase}]).first    
  end

  # def self.find_for_database_authentication(warden_conditions)
  #   conditions = warden_conditions.dup
  #   if login = conditions.delete(:login)
  #     result = where(conditions).where(["lower(username) = :opt OR lower(email) = :opt", {opt: query.downcase}]).first
  #     if result.present?
  #       TwoWayAuthenticate.new(self).send_twowaycode
  #       result
  #     else
  #       result
  #     end
  #   else
  #     where(conditions).first
  #   end
  # end

  def generate_mobile_verification_code
    if mobile_verification_code.blank?
      self[:mobile_verification_code] = MobileNumberService.new(self).send_mobile_verification_code
    end
  end

end
