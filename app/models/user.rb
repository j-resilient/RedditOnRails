# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  session_token   :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    after_initialize :set_session_token
    attr_reader :password

    validates :name, :session_token, presence: true
    validates :password_digest, presence: { message: "Password cannot be empty." }
    validates :name, :session_token, uniqueness: true
    validates :password, length: { minimum: 6, allow_nil: true }

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def self.find_by_credentials(username, password)
        user = User.find_by(name: username)
        return nil if user.nil?
        user.is_password?(password) ? user : nil
    end
    
    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end

    def reset_session!
        self.session_token = self.class.generate_session_token
        self.save!
        self.session_token
    end

    def set_session_token
        self.session_token ||= self.class.generate_session_token
    end
end
