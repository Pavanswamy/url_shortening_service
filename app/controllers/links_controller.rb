class LinksController < ApplicationController

  def check_valid_url
    require 'open-uri'
    url = open(params[:url]).status rescue nil
    if !(url.present? && url[0] = "200")
      @msg = { status: 404, message: "Unable to shorten that link. It is not a valid url." }
    elsif check_presence_of_url
      @msg = { status: 412, message: "Already shorten before: #{$BASE_URL}/#{check_presence_of_url.shorten_url}",
               link: "#{$BASE_URL}/links/#{check_presence_of_url.shorten_url}" }
    else
      key = Link.generate_key
      link = Link.new(original_url: params[:url], shorten_url: key)
      @msg = { status: 200, message: "Shorten URL: #{$BASE_URL}/#{link.shorten_url}",
               link: "#{$BASE_URL}/links/#{link.shorten_url}" } if link.save
    end
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def check_presence_of_url
    link_presence = Link.where(original_url: params[:url]).first rescue nil
    if link_presence
      return link_presence
    else
      return false
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

  def link_params
    params.require(:link).permit(:url)
  end

end
