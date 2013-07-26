class User < ActiveRecord::Base
  include JsonSerializingModel

  validates_presence_of :password, on: :create

  def password=(password)
    write_attribute(:password, BCrypt::Password.create(password))
  end
end
