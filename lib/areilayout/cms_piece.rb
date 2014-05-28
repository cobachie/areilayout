module Areilayout
  
  class CmsPiece < ActiveRecord::Base

    def save_piece(data, title)
    
      return false if data.blank?
      
      check_data(data, title)
      
      return false unless CmsPiece.where(title: data["title"]).blank?
      
      @piece = CmsPiece.new
      @piece.concept_id = data["concept_id"]
      @piece.site_id = data["site_id"]
      @piece.state = data["state"]
      @piece.model = data["model"]
      @piece.name = data["name"]
      @piece.title = data["title"]
      @piece.view_title = data["view_title"]
      @piece.body = data["body"]
      @piece.save!
      
    end
    
    private
    def check_data(data, title)
      data["concept_id"] ||= 1
      data["site_id"] ||= 1
      data["state"] ||= "public"
      data["model"] ||= "Cms::Free"
      data["name"] ||= title
      data["title"] ||= title
      data["view_title"] ||= title
      data
    end
    
  end
    
end
