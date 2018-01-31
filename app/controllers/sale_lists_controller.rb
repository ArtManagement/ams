class SaleListsController < ApplicationController
  def index
    @sort = Sort.select(:sort_key, :sort).all
    @customer = Customer.select(:id, "name || '／' || kana AS customer").order(:kana)
    @artist = Artist.select(:id, "name || '／' || kana AS artist").all.order(:kana)
    @category = Category.select(:id, :category).all.order(:id)
    @technique = Technique.select(:id, :technique).all.order(:id)
    @format = Format.select(:id, :format).all.order(:id)
    sql =
    " SELECT
        s.id AS id,
        s.sale_slip_id AS sale_slip_id,
        s.artwork_id AS artwork_id,
        ss.date AS sale_date,
        cu.name AS customer,
        a.artwork_no AS artwork_no,
        at.name AS artist,
        a.title AS title,
        CASE WHEN (a.size_id != 0) AND (a.size_id IS NOT NULL)
             THEN coalesce(su.size_unit,'') || coalesce(si.size,'')
             ELSE a.edition || CASE WHEN a.edition = ''
                                    THEN ''
                                    ELSE ':'
                               END
                            || coalesce(to_char(a.edition_no,'9999'),'')
                            || CASE WHEN a.edition_limit IS NULL
                                    THEN ''
                                    ELSE '/'
                               END
                            || coalesce(to_char(a.edition_limit,'9999'),'')
        END AS size,
        CASE WHEN (a.technique_id != 0) AND (t.technique IS NOT NULL)
             THEN t.technique
             ELSE c.category
        END AS category,
        f.format AS formats,
        CASE WHEN s.price = 0
             THEN NULL
             ELSE s.price
        END AS sale_price,
        CASE WHEN s.price * ss.tax_rate * ss.tax_class_id = 0
             THEN NULL
             ELSE s.price * ss.tax_rate * ss.tax_class_id
        END AS tax,
        scs.date AS cancel_date,
        ps.date AS purchase_date,
        ct.name AS supplier,
        CASE WHEN pu.price = 0
             THEN NULL
             ELSE pu.price
        END AS purchase_price,
        s.note AS note
      FROM sales AS s
      LEFT OUTER JOIN sale_cancels AS sc ON s.id = sc.sale_id
      LEFT OUTER JOIN sale_cancel_slips AS scs ON sc.sale_cancel_slip_id = scs.id,
           sale_slips AS ss,
           customers AS cu,
           artworks AS a
      LEFT OUTER JOIN artists AS at ON a.artist_id = at.id
      LEFT OUTER JOIN categories AS c ON a.category_id = c.id
      LEFT OUTER JOIN techniques AS t ON a.technique_id = t.id
      LEFT OUTER JOIN sizes AS si ON a.size_id = si.id
      LEFT OUTER JOIN size_units AS su ON a.size_unit_id = su.id
      LEFT OUTER JOIN formats AS f ON a.format_id = f.id
      LEFT OUTER JOIN purchases AS pu ON a.id = pu.artwork_id
      LEFT OUTER JOIN purchase_slips AS ps ON pu.purchase_slip_id = ps.id
      LEFT OUTER JOIN customers AS ct ON ps.customer_id = ct.id
      WHERE s.artwork_id = a.id
      AND   s.sale_slip_id = ss.id
      AND   ss.customer_id = cu.id"
      gon.sale_list_data =  Sale.find_by_sql([sql])
  end

  def search
    sql =
    " SELECT
        s.id AS id,
        s.sale_slip_id AS sale_slip_id,
        s.artwork_id AS artwork_id,
        ss.date AS sale_date,
        cu.name AS customer,
        a.artwork_no AS artwork_no,
        at.name AS artist,
        a.title AS title,
        CASE WHEN (a.size_id != 0) AND (a.size_id IS NOT NULL)
             THEN coalesce(su.size_unit,'') || coalesce(si.size,'')
             ELSE a.edition || CASE WHEN a.edition = ''
                                    THEN ''
                                    ELSE ':'
                               END
                            || coalesce(to_char(a.edition_no,'9999'),'')
                            || CASE WHEN a.edition_limit IS NULL
                                    THEN ''
                                    ELSE '/'
                               END
                            || coalesce(to_char(a.edition_limit,'9999'),'')
        END AS size,
        CASE WHEN (a.technique_id != 0) AND (t.technique IS NOT NULL)
             THEN t.technique
             ELSE c.category
        END AS category,
        f.format AS formats,
        CASE WHEN s.price = 0
             THEN NULL
             ELSE s.price
        END AS sale_price,
        CASE WHEN s.price * ss.tax_rate * ss.tax_class_id = 0
             THEN NULL
             ELSE s.price * ss.tax_rate * ss.tax_class_id
        END AS tax,
        scs.date AS cancel_date,
        ps.date AS purchase_date,
        ct.name AS supplier,
        CASE WHEN pu.price = 0
             THEN NULL
             ELSE pu.price
        END AS purchase_price,
        s.note AS note
      FROM sales AS s
      LEFT OUTER JOIN sale_cancels AS sc ON s.id = sc.sale_id
      LEFT OUTER JOIN sale_cancel_slips AS scs ON sc.sale_cancel_slip_id = scs.id,
           sale_slips AS ss,
           customers AS cu,
           artworks AS a
      LEFT OUTER JOIN artists AS at ON a.artist_id = at.id
      LEFT OUTER JOIN categories AS c ON a.category_id = c.id
      LEFT OUTER JOIN techniques AS t ON a.technique_id = t.id
      LEFT OUTER JOIN sizes AS si ON a.size_id = si.id
      LEFT OUTER JOIN size_units AS su ON a.size_unit_id = su.id
      LEFT OUTER JOIN formats AS f ON a.format_id = f.id
      LEFT OUTER JOIN purchases AS pu ON a.id = pu.artwork_id
      LEFT OUTER JOIN purchase_slips AS ps ON pu.purchase_slip_id = ps.id
      LEFT OUTER JOIN customers AS ct ON ps.customer_id = ct.id
      WHERE s.artwork_id = a.id
      AND   s.sale_slip_id = ss.id
      AND   ss.customer_id = cu.id
      AND   ss.date between :date_from and :date_to
      AND   COALESCE(a.artist_id,0) between :artist_id_from and :artist_id_to
      AND   a.title like :title
      AND   COALESCE(ss.customer_id,0) between :customer_id_from and :customer_id_to
      AND   COALESCE(a.category_id,0) between :category_id_from and :category_id_to
      AND   COALESCE(a.technique_id,0) between :technique_id_from and :technique_id_to
      AND   COALESCE(a.format_id,0) between :format_id_from and :format_id_to"

     if params[:date_from] == ''
       date_from = '2000-01-01'
     else
       date_from = params[:date_from]
     end

     if params[:date_to] == ''
       date_to = '2099-12-31'
     else
       date_to = params[:date_to]
     end

     if params[:artist_id] == ''
       artist_id_from = 0
       artist_id_to = 999999
     else
       artist_id_from = params[:artist_id]
       artist_id_to = params[:artist_id]
     end

     title = params[:title] + '%'

     if params[:customer_id] == ''
       customer_id_from = 0
       customer_id_to = 999999
     else
       customer_id_from = params[:customer_id]
       customer_id_to = params[:customer_id]
     end

     if params[:category_id] == ''
       category_id_from = 0
       category_id_to = 999999
     else
       category_id_from = params[:category_id]
       category_id_to = params[:category_id]
     end

     if params[:technique_id] == ''
       technique_id_from = 0
       technique_id_to = 999999
     else
       technique_id_from = params[:technique_id]
       technique_id_to = params[:technique_id]
     end

     if params[:format_id] == ''
       format_id_from = 0
       format_id_to = 999999
     else
       format_id_from = params[:format_id]
       format_id_to = params[:format_id]
     end

     @sale_search_data =  Sale.find_by_sql([sql,{date_from: date_from, date_to: date_to,
                                                 artist_id_from: artist_id_from, artist_id_to: artist_id_to,
                                                 title: title,
                                                 customer_id_from: customer_id_from, customer_id_to: customer_id_to,
                                                 category_id_from: category_id_from, category_id_to: category_id_to,
                                                 technique_id_from: technique_id_from, technique_id_to: technique_id_to,
                                                 format_id_from: format_id_from, format_id_to: format_id_to}])
     render json: @sale_search_data
  end
end
