class LinkVisit < ActiveRecord::Base
  belongs_to :link

  def self.created_on(date)
    where(['created_at >= ? AND created_at < ?', date, date + 1])
  end
end
