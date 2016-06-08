module ApplicationHelper
  def alert_for(flash_type)
    classes = {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info'
    }
    classes[flash_type.to_sym] || flash_type.to_s
  end

  def form_image_select(post)
    imgurl = post.image.exists? ? post.image.url(:medium) : 'placeholder.png'
    image_tag imgurl, id: 'image-preview', class: 'img-responsive'
  end

  def profile_avatar_select(user)
    imgurl = user.avatar.exists? ? user.avatar.url(:medium) : 'avatar.jpg'
    image_tag imgurl, id: 'image-preview', class: 'img-responsive img-circle profile-image'
  end
end
