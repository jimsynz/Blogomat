class User < ActiveRecord::Base
  include JsonSerializingModel

  validates_presence_of :password, on: :create
  after_initialize :_set_defaults

  def password=(password)
    write_attribute(:password, BCrypt::Password.create(password))
  end

  private

  def _set_defaults
    self.api_secret ||= MicroToken.generate(128)
  end
end
