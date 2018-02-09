class ArtworksController < ApplicationController
  def index
    @artwork = Artwork.new
    @artwork_no = Artwork.select(:id,"artworks.artwork_no")
    @artist = Artist.select(:id, "name || '／' || kana AS artist").order(:kana).all
    @category = Category.select(:id, :category).all
    @technique = Technique.select(:id, :technique).all
    @size = Size.select(:id, :size).all
    @size_unit = SizeUnit.select(:id, :size_unit).all
    @motif = Motif.select(:id, :motif).all
    @format = Format.select(:id, :format).all
  end

  def show
    id = params[:id]
    @artwork = Artwork.find(params[:id])
    @artwork_no = Artwork.select(:id,"artworks.artwork_no")
    @artist = Artist.select(:id, "name || '／' || kana AS artist").order(:kana).all
    @category = Category.select(:id, :category).all
    @technique = Technique.select(:id, :technique).all
    @size = Size.select(:id, :size).all
    @size_unit = SizeUnit.select(:id, :size_unit).all
    @motif = Motif.select(:id, :motif).all
    @format = Format.select(:id, :format).all

    render action: :edit
  end

  def edit

  end

  def create
    @artwork = Artwork.new(artwork_params)
    t = Time.new
    c = Counter.find_by(year: t.year,company_id: 1)
    @artwork.artwork_no = t.year.to_s[2,2] + "-" + sprintf("%05d",c.artwork)
    if @artwork.save
      c.artwork = c.artwork + 1
      c.save
      redirect_to @artwork
    else
      render action: :edit
    end
  end

  def update
    @artwork = Artwork.find(params[:id])
    if @artwork.update_attributes artwork_params
        redirect_to @artwork
    else
      render action: :edit
    end
  end

  private

  def artwork_params
    params.require(:artwork).permit(:artist_id,:title,:category_id,:technique_id,:technique_etc,
                                    :size_unit_id,:size_id,:edition,:edition_no,:edition_limit,
                                    :production_year,:raisonne,:motif_id,:format_id,:heigｈｔ,:width,
                                    :depth,:frame_height,:frame_width,:frame_depth,:frame_unit,
                                    :sign,:signature,:seal,:co_box,:co_seal,:certificate,
                                    :retail_price,:wholesale_price,:note,:image1,:image2,:image3,:image4)
  end

end
