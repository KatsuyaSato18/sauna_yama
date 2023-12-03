class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :profile_image
  validates :name, presence: true
  validates :telephone_number, presence: true
  validates :profile_image, presence: true
  after_commit :crop_profile_image, if: -> { profile_image.attached? }

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザ"
      user.telephone_number = "1234567890"
      unless user.profile_image.attached?
        user.profile_image.attach(io: Rails.root.join("app/assets/images/no_image.jpg").open, filename: 'default-image.jpg', content_type: 'image/jpeg')
      end
    end
  end

  def get_profile_image(width, height)
    if !self.profile_image.attached? || self.profile_image.blob.blank? || !self.profile_image.service.exist?(self.profile_image.key)
      self.profile_image.purge # 既存の添付ファイルを削除
      self.profile_image.attach(io: Rails.root.join("app/assets/images/no_image.jpg").open, filename: 'default-image.jpg', content_type: 'image/jpeg')
    end

    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def guest?
    email == 'guest@example.com'
  end


  def active_for_authentication?
    super && (is_deleted == false)
  end

  def crop_profile_image
    if profile_image.attached?
      image_path = profile_image.service.send(:path_for, profile_image.key)
      return unless File.exist?(image_path)

      image = MiniMagick::Image.new(profile_image.service.send(:path_for, profile_image.key))

    # アスペクト比が正方形でない場合のクロップ
      if image.width != image.height
        size = [image.width, image.height].min
        x = (image.width - size) / 2
        y = (image.height - size) / 2
        cropped_image = image.crop "#{size}x#{size}+#{x}+#{y}"

      # 新しいBlobを作成して、profile_imageにアタッチする
        blob = ActiveStorage::Blob.create_and_upload!(
          io: StringIO.new(cropped_image.to_blob),
          filename: "cropped_#{profile_image.filename}",
          content_type: profile_image.content_type
        )
        self.profile_image.attach(blob)
      end
    end
  end
end
