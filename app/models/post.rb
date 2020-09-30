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

    has_many :post_subs, dependent: :destroy, inverse_of: :post
    has_many :subs, through: :post_subs

    belongs_to :author,
        primary_key: :id,
        foreign_key: :author_id,
        class_name: :User
end
