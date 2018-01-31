class ConsignSlipsController < ApplicationController

    def index
      @consign_slip = ConsignSlip.new
      @slip_no = ConsignSlip.select(:id,:slip_no).order(slip_no: :desc).all
      @staff = Staff.select(:id, :staff).where.order(:staff_no)
      @customer = Customer.select(:id, "name || '／' || kana AS customer").order(:kana)
      @consign_slip.date = Date.current
      @consign_slip.tax_class_id = 0
      @consign_slip.tax_rate = 0.08
      @sort = Sort.select(:sort_key, :sort).all
      gon.consign_artwork_id = []
    end

    def show
      id = params[:id]
      @consign_slip = ConsignSlip.find(params[:id])
      @slip_no = ConsignSlip.select(:id,:slip_no).order(slip_no: :desc).all
      @customer = Customer.select(:id, "name || '／' || kana AS customer").order(:kana)
      @staff = Staff.select(:id, :staff).order(:staff_no)
      @sort = Sort.select(:sort_key, :sort).all
      gon.consign_artwork_id = Artwork.includes({consigns: :consign_slip},:artist,:category,:size).order(:artwork_no).where(consigns: {id: nil})
                                       .pluck(:id, "artwork_no || '　　' || name || '／' || title || '／' || category AS artwork_no")
      gon.consign_data = Consign.includes({artwork: [:artist, :category, :size, :size_unit, :format]})
                                  .where(consign_slip_id: params[:id])
                                  .pluck_to_hash(:id, :artwork_id, :artwork_no, :name, :title, :category, "sizes.size", :size_unit, :format, :price,
                                                 :retail_price, :wholesale_price, :note)

      render action: :edit and return

    end

    def new
      @consign_slip = ConsignSlip.new
      @slip_no = ConsignSlip.select(:id,:slip_no).order(slip_no: :desc).all
      @staff = Staff.select(:id, :staff).where("company_id = 0").order(:staff_no)
      @customer = Customer.select("id, name || '／' || kana AS customer").order(:kana)
      @sort = Sort.select(:sort_key, :sort).all
      @consign_slip.date = Date.current
      @consign_slip.tax_class_id = 0
      @consign_slip.tax_rate = 0.08
      gon.consign_artwork_id = []
    end

    def create
      @consign_slip = ConsignSlip.new(consign_slip_params)
      @counter = Counter.find_by(year: @consign_slip.date.year,company_id: 1)
      @consign_slip.slip_no = "C" + @consign_slip.date.to_s[2,2] + "-" + sprintf("%04d",@counter.consign)
      if @consign_slip.save
        @counter.consign = @counter.consign + 1
        @counter.save
        redirect_to @consign_slip
      else
        render 'new'
      end
    end

    def edit

    end

    def update
      @consign_slip = ConsignSlip.find(params[:id])
      if @consign_slip.update_attributes consign_slip_params
        redirect_to @consign_slip
      else
        render action: :edit
      end
    end

    def artworkGet
      if params[:artwork_id] != '' and params[:artwork_id] != '0'
        @artwork_data = Artwork.includes(:artist, :category, :technique, :size).where(id: params[:artwork_id])
                               .pluck_to_hash(:artwork_no, :name, :title, :category ,:technique)
        if params[:consign_id] == ''
          @consign = Consign.new
          @consign.consign_slip_id = params[:consign_slip_id]
          @consign.artwork_id = params[:artwork_id]
          @consign.price = params[:price]
          @consign.note = params[:note]
          if @consign.save

          end
        else
          @consign = Consign.find(params[:consign_id])
          @consign.artwork_id = params[:artwork_id]
          @consign.price = params[:price]
          @consign.note = params[:note]
          if @consign.save

          end
        end
        render json: @artwork_data
      end
    end

    def priceSet
      if params[:consign_id] != ''
        @consign = Consign.find(params[:consign_id])
        @consign.price = params[:price]
        @consign.note = params[:note]
        if @consign.save

        end
      end
    end

    private
    def consign_slip_params
      params.require(:consign_slip).permit(:slip_no, :customer_id, :date, :slip_class_id, :scheduled_date,:tax_class_id,
                                            :tax_rate, :staff_id, :note, :sort1, :sort2, :sort3)
    end
end
