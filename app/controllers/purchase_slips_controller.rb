class PurchaseSlipsController < ApplicationController
  def index
    @purchase_slip = PurchaseSlip.new
    @slip_no = PurchaseSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @customer = Customer.select(:id, "name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @purchase_slip.date = Date.current
    @purchase_slip.slip_class_id = 0
    @purchase_slip.tax_class_id = 0
    @purchase_slip.tax_rate = 0.08
    @sort = Sort.select(:sort_key, :sort).all
    gon.purchase_artwork_id = []
  end

  def show
    id = params[:id]
    @purchase_slip = PurchaseSlip.find(params[:id])
    @slip_no = PurchaseSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @customer = Customer.select(:id, "name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @sort = Sort.select(:sort_key, :sort).all
    gon.purchase_artwork_id = Artwork.includes({purchases: :purchase_slip},:purchases,:artist,:category,:size).order(:id).where(purchases: {id: nil})
                                     .pluck(:id, "artwork_no || '　　' || name || '／' || title || '／' || category AS artwork_no")
    gon.purchase_data = Purchase.includes({artwork: [:artist, :category, :size, :size_unit, :format]})
                                .where(purchase_slip_id: params[:id])
                                .pluck_to_hash(:id, :artwork_id, :artwork_no, :name, :title, :category, "sizes.size", :size_unit, :format, :price,
                                               :retail_price, :wholesale_price, :note)
    render action: :edit
  end

  def new
    @purchase_slip = PurchaseSlip.new
    @slip_no = PurchaseSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @customer = Customer.select("id, name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @sort = Sort.select(:sort_key, :sort).all
    @purchase_slip.date = Date.current
    @purchase_slip.slip_class_id = 0
    @purchase_slip.tax_class_id = 0
    @purchase_slip.tax_rate = 0.08
        gon.purchase_artwork_id = Artwork.includes({purchases: :purchase_slip},:purchases,:artist,:category,:size).order(:id).where(purchases: {id: nil})
                                     .pluck(:id, "artwork_no || '　　' || name || '／' || title AS artwork_no")
  end

  def create
    @purchase_slip = PurchaseSlip.new(purchase_slip_params)
    @counter = Counter.find_by(year: @purchase_slip.date.year,company_id: 1)
    @purchase_slip.slip_no = "S" + @purchase_slip.date.to_s[2,2] + "-" + sprintf("%04d",@counter.purchase)
    if @purchase_slip.save
      @counter.purchase = @counter.purchase + 1
      @counter.save
      redirect_to @purchase_slip
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    @purchase_slip = PurchaseSlip.find(params[:id])
    if @purchase_slip.update_attributes purchase_slip_params
      redirect_to @purchase_slip
    else
      render action: :edit
    end
  end

  def artworkGet
    if params[:artwork_id] != '' and params[:artwork_id] != '0'
      @artwork_data = Artwork.includes(:artist, :category, :technique, :size).where(id: params[:artwork_id])
                             .pluck_to_hash(:artwork_no, :name, :title, :category ,:technique)
      if params[:purchase_id] == ''
        @purchase = Purchase.new
        @purchase.purchase_slip_id = params[:purchase_slip_id]
        @purchase.artwork_id = params[:artwork_id]
        @purchase.price = params[:price]
        @purchase.note = params[:note]
        if @purchase.save

        end
      else
        @purchase = Purchase.find(params[:purchase_id])
        @purchase.artwork_id = params[:artwork_id]
        @purchase.price = params[:price]
        @purchase.note = params[:note]
        if @purchase.save

        end
      end
      render json: @artwork_data
    end
  end

  def priceSet
    if params[:purchase_id] != ''
      @purchase = Purchase.find(params[:purchase_id])
      @purchase.price = params[:price]
      @purchase.note = params[:note]
      if @purchase.save

      end
    end
  end

  private
  def purchase_slip_params
    params.require(:purchase_slip).permit(:slip_no, :customer_id, :date, :slip_class_id, :scheduled_date,:tax_class_id,
                                          :tax_rate, :staff_id, :note, :sort1, :sort2, :sort3)
  end
end