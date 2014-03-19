class Admin::AppContentSetController < AdminController
  
  def show
    redirect_to action: 'edit'
  end

  def edit
  end

  def update
    if @content.update(params[:app_content_set])
      redirect_to action: 'edit'
    else
      render action: 'edit'
    end   
  end

end
