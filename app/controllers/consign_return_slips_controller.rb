class ConsignReturnSlipsController < ApplicationController
  def index
    @consign_return_slip = ConsignReturnSlip.new
    @slip_no = ConsignReturnSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @customer = Customer.select(:id, "name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @consign_return_slip.date = Date.current
    @sort = Sort.select(:sort_key, :sort).all
    gon.consign_return_artwork_id = []
  end

  def show
    id = params[:id]
    @consign_return_slip = ConsignReturnSlip.find(params[:id])
    @slip_no = ConsignReturnSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @customer = Customer.select(:id, "name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @sort = Sort.select(:sort_key, :sort).all
    gon.consign_return_artwork_id = Consign.includes({artwork: [:artist, :category, :technique, :size, :size_unit, :format]},:consign_returns, :consign_slip).order(:id)
                                             .where(consign_returns: {id: nil})
                                             .pluck(:id, "artwork_no || '　　' || name || '／' || title AS artwork_no")
    gon.consign_return_data = ConsignReturn.includes(consign: [artwork: [:artist, :category, :technique, :size, :size_unit, :format]])
                                             .where(consign_return_slip_id: params[:id])
                                             .pluck_to_hash(:id, :consign_id,:artwork_id, :artwork_no, :name, :title, :category, "sizes.size", :size_unit, :format, :price,:note)

    render action: :edit
  end

  def new
    @consign_return_slip = ConsignReturnSlip.new
    @slip_no = ConsignReturnSlip.select(:id,:slip_no).order(slip_no: :desc).all
    @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
    @customer = Customer.select("id, name || '／' || kana AS customer").where("company_id = 0").order(:kana)
    @sort = Sort.select(:sort_key, :sort).all
    @consign_return_slip.date = Date.current
    gon.consign_return_artwork_id = []
  end

  def create
    @consign_return_slip = ConsignReturnSlip.new(consign_return_slip_params)
    @counter = Counter.find_by(year: @consign_return_slip.date.year,company_id: 1)
    @consign_return_slip.slip_no = "C" + @consign_return_slip.date.to_s[2,2] + "-" + sprintf("%04d",@counter.consign)
    if @consign_return_slip.save
      @counter.consign = @counter.consign + 1
      @counter.save
      redirect_to @consign_return_slip
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    @consign_return_slip = ConsignReturnSlip.find(params[:id])
    if @consign_return_slip.update_attributes consign_return_slip_params
      redirect_to @consign_return_slip
    else
      render action: :edit
    end
  end

  def artworkGet
    if params[:consign_id] != '' and params[:consign_id] != '0'
      @artwork_data = Consign.includes({artwork: [:artist, :category, :technique, :size]}).where(id: params[:consign_id])
                             .pluck_to_hash(:artwork_no, :name, :title, :category , :technique, :price)
      if params[:id] == ''
        @consign_return = ConsignReturn.new
        @consign_return.consign_return_slip_id = params[:consign_return_slip_id]
        @consign_return.consign_id = params[:consign_id]
        @consign_return.note = params[:note]
        if @consign_return.save

        end
      else
        @consign_return = ConsignReturn.find(params[:id])
        @consign_return.consign_id = params[:consign_id]
        @consign_return.note = params[:note]
        if @consign_return.save

        end
      end
      render json: @artwork_data
    end
  end

  private
  def consign_return_slip_params
    params.require(:consign_return_slip).permit(:slip_no, :customer_id, :date, :staff_id, :note, :sort1, :sort2, :sort3)
  end
end
