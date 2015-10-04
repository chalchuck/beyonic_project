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

require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
