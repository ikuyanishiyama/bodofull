class User < ApplicationRecord
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
  validates :password, presence: true, length: { minimum: 6 }
  
  # パスワードのセキュア化
  has_secure_password
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
end
