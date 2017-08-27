class FilterLinks < ActiveJob::Base
  queue_as :default

  def perform
    Link.all.each do |link|
      if link.link_vists.last.created_at <= 3.months.ago.to_datetime
        link.update(is_active: false)
      end
    end
  end
end
