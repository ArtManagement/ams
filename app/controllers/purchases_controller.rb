class PurchasesController < ApplicationController
  def index
    render action: :new
  end

  def show
    @purchase = Purchase.find(params[:id])
    @artwork_no = Purchase.joins(:artwork).select(:id,"artworks.artwork_no")
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
    @purchase = Purchase.new
    @purchase.build_artwork
    @purchase.purchase_slip_id = request.query_parameters["slip_id"]
    @artwork_no = Purchase.joins(:artwork).select(:id,"artworks.artwork_no")
    @artist = Artist.select(:id, "name || '／' || kana AS artist").order(:kana).all
    @category = Category.select(:id, :category).all
    @technique = Technique.select(:id, :technique).all
    @size = Size.select(:id, :size).all
    @size_unit = SizeUnit.select(:id, :size_unit).all
    @motif = Motif.select(:id, :motif).all
    @format = Format.select(:id, :format).all
  end

  def create
    @purchase = Purchase.new(purchase_params)
    @purchase_slip = PurchaseSlip.find(@purchase.purchase_slip_id)
    c = Counter.find_by(year: @purchase_slip.date.year,company_id: 1)
    @purchase.artwork.artwork_no = @purchase_slip.date.to_s[2,2] + "-" + sprintf("%05d",c.artwork)
    c.artwork = c.artwork + 1
    c.save
    if @purchase.save
      redirect_to @purchase
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    @purchase = Purchase.find(params[:id])
    @purchase.artwork.update(artwork_update_params)
    if @purchase.update(purchase_update_params)
      redirect_to @purchase
    else
      render action: :edit
    end
  end

  private

    def purchase_params
      params.require(:purchase).permit(:purchase_slip_id,:price,artwork_attributes: [:artist_id,:title,:category_id,:technique_id,:technique_etc,
                                                                   :size_unit_id,:size_id,:edition,:edition_no,:edition_limit,
                                                                   :production_year,:raisonne,:motif_id,:format_id,:heigｈｔ,:width,
                                                                   :depth,:frame_height,:frame_width,:frame_depth,:frame_unit,
                                                                   :sign,:signature,:seal,:co_box,:co_seal,:certificate,
                                                                   :retail_price,:wholesale_price,:note])
    end

    def purchase_update_params
      params.require(:purchase).permit(:price)
    end

    def artwork_update_params
      params.require(:purchase).permit(:artist_id,:title,:category_id,:technique_id,:technique_etc,
                                      :size_unit_id,:size_id,:edition,:edition_no,:edition_limit,
                                      :production_year,:raisonne,:motif_id,:format_id,:heigｈｔ,:width,
                                      :depth,:frame_height,:frame_width,:frame_depth,:frame_unit,
                                      :sign,:signature,:seal,:co_box,:co_seal,:certificate,
                                      :retail_price,:wholesale_price,:note)
    end

end
