class LinksController < ApplicationController

  def check_valid_url
    require 'open-uri'
    return redirect_to root_path, notice: "already present" if Link.where(original_url: params[:url]).present?
    url = open(params[:url]).status rescue nil
    if url.present? && url[0] = "200"
      su = generate_shorten_link
      link = Link.create(original_url: params[:url], shorten_url: su)
      redirect_to root_path, alert: "shorten_url: localhost:3000/#{link.shorten_url}"
    else
      redirect_to root_path, alert: "Unable to shorten that link. It is not a valid url."
    end
  end

 def show
    key = params[:id]
    @link = Link.where(shorten_url: key).first
    if @link.present?
      @link_count = @link.link_visits
    else
    end
  end

  protected

  def generate_shorten_link
    rand_number = rand(4..7)
    rand(36**rand_number).to_s(36)
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def link_params
    params.fetch(:link, {})
  end
end
