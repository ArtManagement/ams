class TrustSlipsController < ApplicationController
  def index
    @trust_slip = TrustSlip.new
    @slip_no = TrustSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @customer = Customer.select(:id, "name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @trust_slip.date = Date.current
    @trust_slip.tax_class_id = 0
    @trust_slip.tax_rate = 0.08
    @sort = Sort.select(:sort_key, :sort).all
    gon.trust_artwork_id = Artwork.includes({trusts: :trust_slip},:artist,:category,:size).order(:id).where(trusts: {id: nil})
                                     .pluck(:id, "artwork_no || '　　' || name || '／' || title AS artwork_no")
  end

  def show
    id = params[:id]
    @trust_slip = TrustSlip.find(params[:id])
    @slip_no = TrustSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @customer = Customer.select(:id, "name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @sort = Sort.select(:sort_key, :sort).all
    gon.trust_artwork_id = Artwork.includes({trusts: :trust_slip}, :artist, :category, :size).order(:id).where(trusts: {id: nil})
                                     .pluck(:id, "artwork_no || '　　' || name || '／' || title || '／' || category AS artwork_no")
    gon.trust_data = Trust.includes({artwork: [:artist, :category, :size, :size_unit, :format]})
                                .where(trust_slip_id: params[:id])
                                .pluck_to_hash(:id, :artwork_id, :artwork_no, :name, :title, :category, "sizes.size", :size_unit, :format, :price,
                                               :retail_price, :wholesale_price, :note)
    render action: :edit
  end

  def new
    @trust_slip = TrustSlip.new
    @slip_no = TrustSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @customer = Customer.select("id, name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @sort = Sort.select(:sort_key, :sort).all
    @trust_slip.date = Date.current
    @trust_slip.tax_class_id = 0
    @trust_slip.tax_rate = 0.08
        gon.trust_artwork_id = Artwork.includes({trusts: :trust_slip},:artist, :category, :size).order(:id).where(trusts: {id: nil})
                                     .pluck(:id, "artwork_no || '　　' || name || '／' || title AS artwork_no")
  end

  def create
    @trust_slip = TrustSlip.new(trust_slip_params)
    @counter = Counter.find_by(year: @trust_slip.date.year,company_id: 1)
    @trust_slip.slip_no = "T" + @trust_slip.date.to_s[2,2] + "-" + sprintf("%04d",@counter.trust)
    if @trust_slip.save
      @counter.trust = @counter.trust + 1
      @counter.save
      redirect_to @trust_slip
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    @trust_slip = TrustSlip.find(params[:id])
    if @trust_slip.update_attributes trust_slip_params
      redirect_to @trust_slip
    else
      render action: :edit
    end
  end

  def artworkGet
    if params[:artwork_id] != '' and params[:artwork_id] != '0'
      @artwork_data = Artwork.includes(:artist, :category, :technique, :size).where(id: params[:artwork_id])
                             .pluck_to_hash(:artwork_no, :name, :title, :category ,:technique)
      if params[:trust_id] == ''
        @trust = Trust.new
        @trust.trust_slip_id = params[:trust_slip_id]
        @trust.artwork_id = params[:artwork_id]
        @trust.price = params[:price]
        @trust.note = params[:note]
        if @trust.save

        end
      else
        @trust = Trust.find(params[:trust_id])
        @trust.artwork_id = params[:artwork_id]
        @trust.price = params[:price]
        @trust.note = params[:note]
        if @trust.save

        end
      end
      render json: @artwork_data
    end
  end

  def priceSet
    if params[:trust_id] != ''
      @trust = Trust.find(params[:trust_id])
      @trust.price = params[:price]
      @trust.note = params[:note]
      if @trust.save

      end
    end
  end

  private
  def trust_slip_params
    params.require(:trust_slip).permit(:slip_no, :customer_id, :date, :slip_class_id, :scheduled_date,:tax_class_id,
                                          :tax_rate, :staff_id, :note, :sort1, :sort2, :sort3)
  end
end
