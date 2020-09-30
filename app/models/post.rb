# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  url        :string
#  content    :text
#  sub_id     :integer          not null
#  author_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Post < ApplicationRecord
    validates :title, :author_id, presence: true
    validate :at_least_one_associated_sub

    def at_least_one_associated_sub
        if self.subs.size < 1
            errors.add(:you, "must select at least one sub.")
        end
    end

    has_many :post_subs, dependent: :destroy, inverse_of: :post
    has_many :subs, through: :post_subs

    belongs_to :author,
        primary_key: :id,
        foreign_key: :author_id,
        class_name: :User
end
