# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    after_initialize :ensure_session_token
    attr_reader :password

    validates :username, :session_token, presence: true
    validates :password_digest, presence: { message: "Password cannot be empty." }
    validates :username, :session_token, uniqueness: true
    validates :password, length: { minimum: 6, allow_nil: true }

    has_many :subs,
        primary_key: :id,
        foreign_key: :moderator_id,
        class_name: :Sub,
        dependent: :destroy
    has_many :posts,
        primary_key: :id,
        foreign_key: :author_id,
        class_name: :Post
    has_many :comments,
        primary_key: :id,
        foreign_key: :author_id,
        class_name: :Comment

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        return nil if user.nil?
        user.is_password?(password) ? user : nil
    end
    
    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end

    def reset_session!
        self.session_token = self.class.generate_session_token
        self.save!
    end

    def ensure_session_token
        self.session_token ||= self.class.generate_session_token
    end
end
