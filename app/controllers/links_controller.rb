class LinksController < ApplicationController

  def check_valid_url
    require 'open-uri'
    url = open(params[:url]).status rescue nil
    if url.present? && url[0] = "200"
      su = generate_shorten_link(params[:url])
      redirect_to root_path, alert: "shorten_url: localhost:3000/#{su}"
    else
      redirect_to root_path, alert: "Unable to shorten that link. It is not a valid url."
    end
  end 


  private
    # Use callbacks to share common setup or constraints between actions.
    def generate_shorten_link(url)
      rand_number = rand(4..7)
      key = rand(36**rand_number).to_s(36)
      link = Link.create(original_url: params[:url], shorten_url: key)
      return link.shorten_url
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.fetch(:link, {})
    end
end
