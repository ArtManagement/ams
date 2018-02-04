class TrustsController < ApplicationController
  def index
    render action: :new
  end

  def show
    @trust = Trust.find(params[:id])
    @artwork_no = Trust.joins(:artwork).select(:id,"artworks.artwork_no")
    @artist = Artist.select(:id, "name || '／' || kana AS artist").order(:kana).all
    @category = Category.select(:id, :category).all
    @technique = Technique.select(:id, :technique).all
    @size = Size.select(:id, :size).all
    @size_unit = SizeUnit.select(:id, :size_unit).all
    @motif = Motif.select(:id, :motif).all
    @format = Format.select(:id, :format).all

    render action: :edit
  end

  def new
    @trust = Trust.new
    @trust.build_artwork
    @trust.trust_slip_id = request.query_parameters["slip_id"]
    @artwork_no = Trust.joins(:artwork).select(:id,"artworks.artwork_no")
    @artist = Artist.select(:id, "name || '／' || kana AS artist").order(:kana).all
    @category = Category.select(:id, :category).all
    @technique = Technique.select(:id, :technique).all
    @size = Size.select(:id, :size).all
    @size_unit = SizeUnit.select(:id, :size_unit).all
    @motif = Motif.select(:id, :motif).all
    @format = Format.select(:id, :format).all
  end

  def create
    @trust = Trust.new(trust_params)
    @trust_slip = TrustSlip.find(@trust.trust_slip_id)
    c = Counter.find_by(year: @trust_slip.date.year,company_id: 1)
    @trust.artwork.artwork_no = @trust_slip.date.to_s[2,2] + "-" + sprintf("%05d",c.artwork)
    c.artwork = c.artwork + 1
    c.save
    if @trust.save
      redirect_to @trust
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    @trust = Trust.find(params[:id])
    @trust.artwork.update(artwork_update_params)
    if @trust.update(trust_update_params)
      redirect_to @trust
    else
      render action: :edit
    end
  end

  private

    def trust_params
      params.require(:trust).permit(:trust_slip_id,:price,artwork_attributes: [:artist_id,:title,:category_id,:technique_id,:technique_etc,
                                                                   :size_unit_id,:size_id,:edition,:edition_no,:edition_limit,
                                                                   :production_year,:raisonne,:motif_id,:format_id,:heigｈｔ,:width,
                                                                   :depth,:frame_height,:frame_width,:frame_depth,:frame_unit,
                                                                   :sign,:signature,:seal,:co_box,:co_seal,:certificate,
                                                                   :retail_price,:wholesale_price,:note])
    end

    def trust_update_params
      params.require(:trust).permit(:price)
    end

    def artwork_update_params
      params.require(:trust).permit(:artist_id,:title,:category_id,:technique_id,:technique_etc,
                                      :size_unit_id,:size_id,:edition,:edition_no,:edition_limit,
                                      :production_year,:raisonne,:motif_id,:format_id,:heigｈｔ,:width,
                                      :depth,:frame_height,:frame_width,:frame_depth,:frame_unit,
                                      :sign,:signature,:seal,:co_box,:co_seal,:certificate,
                                      :retail_price,:wholesale_price,:note)
    end

end
