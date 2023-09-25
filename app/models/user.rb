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
  after_commit :crop_profile_image, if: -> { profile_image.attached? }



  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app', 'assets', 'images', 'no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width,height]).processed
  end

  def crop_profile_image
    if profile_image.attached?
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
