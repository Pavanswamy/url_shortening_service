class PagesController < ApplicationController
  def show
    url = Link.where(shorten_url: params[:key])
    if url.present?
      url.first.update(count:  url.count + 1)
      original_url = url.first.original_url
      redirect_to original_url
    else
      redirect_to root_path, notice: "url broken"
    end
  end
end
