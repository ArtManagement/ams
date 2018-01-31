class PurchasesController < ApplicationController
  def index
    render action: :new
  end

  def show
    id = params[:id]
    @purchase = Purchase.find(params[:id])
    @artwork = Artwork.find(@purchase.artwork_id)
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
    @artwork = Artwork.new
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
    @artwork = Artwork.new(artwork_params)
    @purchase = Purchase.new(purchase_params)
    @purchase_slip = PurchaseSlip.find_by(slip_no: 'S17-0001')
    c = Counter.find_by(year: @purchase_slip.date.year,company_id: 1)
    @artwork.artwork_no = @purchase_slip.date.to_s[2,2] + "-" + sprintf("%05d",c.artwork)
    if @artwork.save
      c.artwork = c.artwork + 1
      c.save
      @purchase.artwork_id = @artwork.id
      @purchase.purchase_slip_id = 'S17-0001'
      if @purchase.save
        redirect_to @purchase
      else
        render 'new'
      end
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    @purchase = Purchase.find(params[:id])
    @artwork = Artwork.find(@purchase.artwork_id)
    if @artwork.update_attributes artwork_params
      if @purchase.update_attributes purchase_params
        redirect_to @purchase
      end
    else
      render action: :edit
    end
  end

  private

  def purchase_params
    params.require(:purchase).permit(:price)
  end

  def artwork_params
    params.require(:artwork).permit(:artist_id,:title)
  end

end
