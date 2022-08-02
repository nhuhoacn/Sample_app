class Micropost < ApplicationRecord
  MICROPOST_ATTRIBUTES = %i(content image).freeze
  belongs_to :user
  has_one_attached :image
  validates :content, presence: true,
    length: {maximum: Settings.micropost.content_max}
  validates :image, content_type: {in: Settings.micropost.image_path,
                                message: :wrong_format},
                                size: {less_than: Settings.micropost.image_size.megabytes,
                                         message: :too_big}
  scope :newest, ->{order(created_at: :desc)}

  delegate :name, to: :user, prefix: :user, allow_nil: true

  def display_image
    image.variant(resize_to_limit: Settings.micropost.resize_to_limit)
  end
end
