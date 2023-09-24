class Post < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_one_attached :image
  validates :image, presence: true
  validates :title, presence: true
  validates :sauna_name, presence: true
  validates :address, presence: true
  validates :caption, presence: true
  enum status: { published: 0, draft: 1,  unpublished: 2 }

  def get_image
    unless image.attached?
      file_path = Rails.root.join('app', 'assets', 'images', 'no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

end
