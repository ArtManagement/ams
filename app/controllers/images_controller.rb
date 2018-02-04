class ImagesController < ApplicationController
  def index
    @image = Image.new

  end

  def show
    @image = Image

    render action: :edit
  end

  def edit

  end

  def create
    @image = Image.new(image_params)

    if @image.save

      redirect_to @image
    else
      render action: :edit
    end
  end

  def update
    @image = Image.find(params[:id])
    if @image.update_attributes image_params
        redirect_to @image
    else
      render action: :edit
    end
  end

  private

  def image_params
    params.require(:image).permit(:artist_id,:title,:category_id,:technique_id,:technique_etc,
                                    :size_unit_id,:size_id,:image1,:image2,:image3,:image4)
  end

end
