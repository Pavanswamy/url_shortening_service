class PagesController < ApplicationController
  def show
    url = Link.where(shorten_url: params[:key]).first
    if url.present?
      total_visits = url.link_visits
      if total_visits
        today_visits = total_visits.created_on(Date.today).where(link_id: url.id)
        today_visits.present? ? today_visits.first.update(count: today_visits.first.count + 1) :
          LinkVisit.create(count: 1, link_id: url.id)
      else
        LinkVisit.create(count: 1, link_id: url.id)
      end
      original_url = url.original_url
      redirect_to original_url
    else
      redirect_to root_path, notice: "url broken"
    end
  end
end
