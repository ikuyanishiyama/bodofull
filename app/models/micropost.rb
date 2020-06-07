class Micropost < ApplicationRecord
  # Userモデルとの紐付け
  belongs_to :user
  
  # 最新の投稿が先頭に表示されるように
  default_scope -> { order(created_at: :desc) }
  
  # Pictureアップローダーとの紐付け
  mount_uploader :picture, PictureUploader
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size
  
  # アップロードされた画像のサイズをバリデーションする
  def picture_size
    if picture.size > 10.megabytes
      errors.add(:picture, "10MBより小さいサイズにしてください")
    end
  end
  
end
