class SaleCancelSlipsController < ApplicationController
  def index
    @sale_cancel_slip = SaleCancelSlip.new
    @slip_no = SaleCancelSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @customer = Customer.select(:id, "name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @sale_cancel_slip.date = Date.current
    @sort = Sort.select(:sort_key, :sort).all
    gon.sale_cancel_artwork_id = []
  end

  def show
    id = params[:id]
    @sale_cancel_slip = SaleCancelSlip.find(params[:id])
    @slip_no = SaleCancelSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @customer = Customer.select(:id, "name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @sort = Sort.select(:sort_key, :sort).all
    gon.sale_cancel_artwork_id = Sale.includes({artwork: [:artist, :category, :technique, :size, :size_unit, :format]},:sale_cancels, :sale_slip).order(:id)
                                             .where(sale_cancels: {id: nil})
                                             .pluck(:id, "artwork_no || '　　' || name || '／' || title AS artwork_no")
    gon.sale_cancel_data = SaleCancel.includes(sale: [artwork: [:artist, :category, :technique, :size, :size_unit, :format]])
                                             .where(sale_cancel_slip_id: params[:id])
                                             .pluck_to_hash(:id, :sale_id,:artwork_id, :artwork_no, :name, :title, :category, "sizes.size", :size_unit, :format, :price,:note)

    render action: :edit
  end

  def new
    @sale_cancel_slip = SaleCancelSlip.new
    @slip_no = SaleCancelSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @customer = Customer.select("id, name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @sort = Sort.select(:sort_key, :sort).all
    @sale_cancel_slip.date = Date.current
    gon.sale_cancel_artwork_id = []
  end

  def create
    @sale_cancel_slip = SaleCancelSlip.new(sale_cancel_slip_params)
    @counter = Counter.find_by(year: @sale_cancel_slip.date.year,company_id: 1)
    @sale_cancel_slip.slip_no = "U" + @sale_cancel_slip.date.to_s[2,2] + "-" + sprintf("%04d",@counter.sale)
    if @sale_cancel_slip.save
      @counter.sale = @counter.sale + 1
      @counter.save
      redirect_to @sale_cancel_slip
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    @sale_cancel_slip = SaleCancelSlip.find(params[:id])
    if @sale_cancel_slip.update_attributes sale_cancel_slip_params
      redirect_to @sale_cancel_slip
    else
      render action: :edit
    end
  end

  def artworkGet
    if params[:sale_id] != '' and params[:sale_id] != '0'
      @artwork_data = Sale.includes({artwork: [:artist, :category, :technique, :size]}).where(id: params[:sale_id])
                             .pluck_to_hash(:artwork_no, :name, :title, :category , :technique, :price)
      if params[:id] == ''
        @sale_cancel = SaleCancel.new
        @sale_cancel.sale_cancel_slip_id = params[:sale_cancel_slip_id]
        @sale_cancel.sale_id = params[:sale_id]
        @sale_cancel.note = params[:note]
        if @sale_cancel.save

        end
      else
        @sale_cancel = SaleCancel.find(params[:id])
        @sale_cancel.sale_id = params[:sale_id]
        @sale_cancel.note = params[:note]
        if @sale_cancel.save

        end
      end
      render json: @artwork_data
    end
  end

  private
  def sale_cancel_slip_params
    params.require(:sale_cancel_slip).permit(:slip_no, :customer_id, :date, :staff_id, :note, :sort1, :sort2, :sort3)
  end
end
