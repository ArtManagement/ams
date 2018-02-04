class PayableListsController < ApplicationController
  def index
    @sort = Sort.select(:sort_key, :sort).all
    @customer = Customer.select(:id, "name || '／' || kana AS customer").order(:kana)
    @artist = Artist.select(:id, "name || '／' || kana AS artist").all.order(:kana)
    @category = Category.select(:id, :category).all.order(:id)
    @technique = Technique.select(:id, :technique).all.order(:id)
    @format = Format.select(:id, :format).all.order(:id)
    sql =
    "SELECT p.id AS id,
       p.purchase_slip_id AS purchase_slip_id,
       p.artwork_id AS artwork_id,
       ps.date AS purchase_date,
       cu.name AS supplier,
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
       CASE WHEN p.price * ps.tax_rate * ps.tax_class_id = 0
            THEN p.price - coalesce(pa.amount,0)
            ELSE p.price + p.price * ps.tax_rate * ps.tax_class_id - coalesce(pa.amount,0)
       END AS payable_amount,
       CASE WHEN p.price * ps.tax_rate * ps.tax_class_id = 0
            THEN p.price
            ELSE p.price + p.price * ps.tax_rate * ps.tax_class_id
       END AS purchase_amount,
       CASE WHEN pa.amount IS NOT NULL
            THEN pa.amount
           ELSE NULL
       END AS payment_amount,
       pas.date AS payment_date,
       p.note AS note,
       CASE WHEN pa.id IS NULL
            THEN '買掛'
            ELSE '出金済'
       END AS status
     FROM   purchases AS p
     LEFT OUTER JOIN payments AS pa ON p.id = pa.purchase_id
       LEFT OUTER JOIN payment_slips AS pas ON pa.payment_slip_id = pas.id
     LEFT OUTER JOIN purchase_cancels AS pc ON p.id = pc.purchase_id
           ,purchase_slips AS ps
     LEFT OUTER JOIN customers AS cu ON ps.customer_id = cu.id
           ,artworks AS a
     LEFT OUTER JOIN artists AS at ON a.artist_id = at.id
     LEFT OUTER JOIN categories AS c ON a.category_id = c.id
     LEFT OUTER JOIN techniques AS t ON a.technique_id = t.id
     LEFT OUTER JOIN sizes AS si ON a.size_id = si.id
     LEFT OUTER JOIN size_units AS su ON a.size_unit_id = su.id
     LEFT OUTER JOIN formats AS f ON a.format_id = f.id
     WHERE p.artwork_id = a.id
     AND   p.purchase_slip_id = ps.id"

     gon.payable_list_data =  Purchase.find_by_sql([sql])

 end

 def search
    sql =
    "SELECT p.id AS id,
       p.purchase_slip_id AS purchase_slip_id,
       p.artwork_id AS artwork_id,
       ps.date AS purchase_date,
       cu.name AS supplier,
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
       CASE WHEN p.price * ps.tax_rate * ps.tax_class_id = 0
            THEN p.price - coalesce(pa.amount,0)
            ELSE p.price + p.price * ps.tax_rate * ps.tax_class_id - coalesce(pa.amount,0)
       END AS payable_amount,
       CASE WHEN p.price * ps.tax_rate * ps.tax_class_id = 0
            THEN p.price
            ELSE p.price + p.price * ps.tax_rate * ps.tax_class_id
       END AS purchase_amount,
       CASE WHEN pa.amount IS NOT NULL
            THEN pa.amount
            ELSE NULL
       END AS payment_amount,
       pas.date AS payment_date,
       p.note AS note,
       CASE WHEN pa.id IS NULL
            THEN '買掛'
            ELSE '出金済'
       END AS status
     FROM   purchases AS p
     LEFT OUTER JOIN payments AS pa ON p.id = pa.purchase_id
       LEFT OUTER JOIN payment_slips AS pas ON pa.payment_slip_id = pas.id
     LEFT OUTER JOIN purchase_cancels AS pc ON p.id = pc.purchase_id
           ,purchase_slips AS ps
     LEFT OUTER JOIN customers AS cu ON ps.customer_id = cu.id
           ,artworks AS a
     LEFT OUTER JOIN artists AS at ON a.artist_id = at.id
     LEFT OUTER JOIN categories AS c ON a.category_id = c.id
     LEFT OUTER JOIN techniques AS t ON a.technique_id = t.id
     LEFT OUTER JOIN sizes AS si ON a.size_id = si.id
     LEFT OUTER JOIN size_units AS su ON a.size_unit_id = su.id
     LEFT OUTER JOIN formats AS f ON a.format_id = f.id
     WHERE p.artwork_id = a.id
     AND   p.purchase_slip_id = ps.id
     AND   ps.date between :date_from and :date_to
     AND   COALESCE(a.artist_id,0) between :artist_id_from and :artist_id_to
     AND   a.title like :title
     AND   COALESCE(ps.customer_id,0) between :supplier_id_from and :supplier_id_to
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

     title = '%' + params[:title] + '%'

     if params[:supplier_id] == ''
       supplier_id_from = 0
       supplier_id_to = 999999
     else
       supplier_id_from = params[:supplier_id]
       supplier_id_to = params[:supplier_id]
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

     @payable_search_data =  Purchase.find_by_sql([sql,{date_from: date_from, date_to: date_to,
                                                        artist_id_from: artist_id_from, artist_id_to: artist_id_to,
                                                        title: title,
                                                        supplier_id_from: supplier_id_from, supplier_id_to: supplier_id_to,
                                                        category_id_from: category_id_from, category_id_to: category_id_to,
                                                        technique_id_from: technique_id_from, technique_id_to: technique_id_to,
                                                        format_id_from: format_id_from, format_id_to: format_id_to}])
     render json: @payable_search_data
　 end
end
