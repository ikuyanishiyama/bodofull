class User < ApplicationRecord
  # Micropostモデルとの紐付け
  has_many :microposts
  
  
  attr_accessor :remember_token, :reset_token
  before_save { self.email = self.email.downcase }
  
  # nameのバリデーション
  validates :name, presence: true, length: { maximum: 50 }
  
  # emailのバリデーション
  # 正規表現
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX},
                    uniqueness: { case_sensitive:  false }
  
  # passwordのバリデーション
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  # パスワードのセキュア化
  has_secure_password
  
  # imageのアップローダーとユーザーを紐付ける
  mount_uploader :image, ImageUploader
  
  # imageのリサイズ
  validate :image_size
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # rememberトークンをデータベースに保存する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # パスワード再設定の有効期限が切れている場合はtrueを返す
  def password_reset_expired?  
    reset_sent_at < 2.hours.ago
  end
  
  private
  
    # アップロードされた画像のサイズをバリデーションする
    def image_size
      if image.size > 5.megabytes
        errors.add(:image, "5MBより小さい画像にしてください")
      end
    end
end
