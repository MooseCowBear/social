module RemoveImage
  extend ActiveSupport::Concern

  #bc post has a validation for presence of image or body
  #wanted to tie purging of attached image to update of model instance.
  #modifying params passed from the form ensures that if a user deletes
  #a post's body and checks the remove image checkbox, the change will be
  #rejected. 
  def modify_params_for_image_removal(strong_params)
    if strong_params[:remove_image] == "1" && !strong_params[:image]
      return strong_params.merge(image: nil)
    end
    strong_params
  end
end