class Post < ActiveRecord::Base
  include JsonSerializingModel

  belongs_to :user

  def self.published
    where('published_at <= ?', Time.now)
  end

  def self.in_reverse_chronological_order
    order(:published_at).reverse_order
  end

  def self.paginate(page_number=0, per_page=20)
    page_number = 0  unless page_number
    per_page    = 20 unless per_page
    offset(page_number * per_page).limit(per_page)
  end
end
