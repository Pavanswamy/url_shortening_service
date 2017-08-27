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
      su = generate_shorten_link
      link = Link.create(original_url: params[:url], shorten_url: su)
      @msg = { status: 200, message: "Shorten URL: #{$BASE_URL}/#{link.shorten_url}",
               link: " #{$BASE_URL}/links/#{link.shorten_url}" }
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
