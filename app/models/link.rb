class Link < ActiveRecord::Base
  has_many 	:link_visits, dependent: :destroy
  validates :original_url, presence: true, uniqueness: true
  validates :shorten_url, uniqueness: true

  def self.active
    where(is_active: true)
  end

  def self.generate_key
    key = loop do
      key = rand(36**rand(4..7)).to_s(36)
      break key unless Link.active.exists?(shorten_url: key)
    end
    return key
  end
end
