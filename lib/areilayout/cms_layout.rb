module Areilayout
  
  class CmsLayout < ActiveRecord::Base
    
    def save_layout(layout_name, head, body)
      
      @layout = CmsLayout.new
      @layout.concept_id = 1
      @layout.site_id = 1
      @layout.state = "public"
      @layout.name = layout_name
      @layout.title = layout_name
      @layout.head = head
      @layout.body = body
#      @layout.in_creator = {'group_id' => 2, 'user_id' => 1}
      @layout.save!
    end
  end
  
end
