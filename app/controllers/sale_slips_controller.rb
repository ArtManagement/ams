class SaleSlipsController < ApplicationController
  def index
    @sale_slip = SaleSlip.new
    @slip_no = SaleSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @customer = Customer.select(:id, "name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @sale_slip.date = Date.current
    @sale_slip.tax_class_id = 0
    @sale_slip.tax_rate = 0.08
    @sort = Sort.select(:sort_key, :sort).all
    gon.sale_artwork_id = Artwork.includes({sales: :sale_slip},:artist,:category,:size).order(:id).where(sales: {id: nil})
                                     .pluck(:id, "artwork_no || '　　' || name || '／' || title AS artwork_no")
  end

  def show
    id = params[:id]
    @sale_slip = SaleSlip.find(params[:id])
    @slip_no = SaleSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @customer = Customer.select(:id, "name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @sort = Sort.select(:sort_key, :sort).all
    gon.sale_artwork_id = Artwork.includes({sales: :sale_slip}, :artist, :category, :size).order(:id).where(sales: {id: nil})
                                     .pluck(:id, "artwork_no || '　　' || name || '／' || title || '／' || category AS artwork_no")
    gon.sale_data = Sale.includes({artwork: [:artist, :category, :size, :size_unit, :format]})
                                .where(sale_slip_id: params[:id])
                                .pluck_to_hash(:id, :artwork_id, :artwork_no, :name, :title, :category, "sizes.size", :size_unit, :format, :price,
                                               :retail_price, :wholesale_price, :note)
    render action: :edit
  end

  def new
    @sale_slip = SaleSlip.new
    @slip_no = SaleSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @customer = Customer.select("id, name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @sort = Sort.select(:sort_key, :sort).all
    @sale_slip.date = Date.current
    @sale_slip.tax_class_id = 0
    @sale_slip.tax_rate = 0.08
        gon.sale_artwork_id = Artwork.includes({sales: :sale_slip},:artist, :category, :size).order(:id).where(sales: {id: nil})
                                     .pluck(:id, "artwork_no || '　　' || name || '／' || title AS artwork_no")
  end

  def create
    @sale_slip = SaleSlip.new(sale_slip_params)
    @counter = Counter.find_by(year: @sale_slip.date.year,company_id: 1)
    @sale_slip.slip_no = "U" + @sale_slip.date.to_s[2,2] + "-" + sprintf("%04d",@counter.sale)
    if @sale_slip.save
      @counter.sale = @counter.sale + 1
      @counter.save
      redirect_to @sale_slip
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    @sale_slip = SaleSlip.find(params[:id])
    if @sale_slip.update_attributes sale_slip_params
      redirect_to @sale_slip
    else
      render action: :edit
    end
  end

  def artworkGet
    if params[:artwork_id] != '' and params[:artwork_id] != '0'
      @artwork_data = Artwork.includes(:artist, :category, :technique, :size).where(id: params[:artwork_id])
                             .pluck_to_hash(:artwork_no, :name, :title, :category ,:technique)
      if params[:sale_id] == ''
        @sale = Sale.new
        @sale.sale_slip_id = params[:sale_slip_id]
        @sale.artwork_id = params[:artwork_id]
        @sale.price = params[:price]
        @sale.note = params[:note]
        if @sale.save

        end
      else
        @sale = Sale.find(params[:sale_id])
        @sale.artwork_id = params[:artwork_id]
        @sale.price = params[:price]
        @sale.note = params[:note]
        if @sale.save

        end
      end
      render json: @artwork_data
    end
  end

  def priceSet
    if params[:sale_id] != ''
      @sale = Sale.find(params[:sale_id])
      @sale.price = params[:price]
      @sale.note = params[:note]
      if @sale.save

      end
    end
  end

  private
  def sale_slip_params
    params.require(:sale_slip).permit(:slip_no, :customer_id, :date, :slip_class_id, :scheduled_date,:tax_class_id,
                                          :tax_rate, :staff_id, :note, :sort1, :sort2, :sort3)
  end
end
