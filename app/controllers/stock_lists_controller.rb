class StockListsController < ApplicationController
  def index
    @sort = Sort.select(:sort_key, :sort).all
    @customer = Customer.select(:id, "name || '／' || kana AS customer").order(:kana)
    @artist = Artist.select(:id, "name || '／' || kana AS artist").all.order(:kana)
    @category = Category.select(:id, :category).all.order(:id)
    @technique = Technique.select(:id, :technique).all.order(:id)
    @format = Format.select(:id, :format).all.order(:id)
    @warehouse = Warehouse.select(:id, :warehouse).all.order(:id)
    sql =
    "SELECT a.id AS id,
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
       CASE WHEN (a.technique_id != 0) AND (te.technique IS NOT NULL)
            THEN te.technique
            ELSE ca.category
       END AS category,
       f.format AS formats,
       CASE WHEN a.retail_price = 0
            THEN NULL
            ELSE a.retail_price
       END AS retail_price,
       CASE WHEN a.wholesale_price = 0
            THEN NULL
            ELSE a.wholesale_price
       END AS wholesale_price,
       CASE WHEN p.price IS NOT NULL
            THEN CASE WHEN p.price = 0
                      THEN NULL
                      ELSE p.price
                 END
            ELSE CASE WHEN t.price = 0
                      THEN NULL
                      ELSE t.price
                 END
      END AS cost,
       CASE WHEN p.price * ps.tax_rate * ps.tax_class_id = 0
            THEN NULL
            ELSE p.price * ps.tax_rate * ps.tax_class_id
       END AS tax,
       cu.name AS customer,
       p.note AS note,
       CASE WHEN c.id IS NOT NULL
            THEN '委託'
            ELSE CASE WHEN t.id IS NOT NULL
                      THEN '受託'
                 END
       END AS status,
       CASE WHEN i.id IS NOT NULL
            THEN '◯'
            ELSE ''
        END image
     FROM artworks AS a
     LEFT OUTER JOIN artists AS at ON a.artist_id = at.id
     LEFT OUTER JOIN categories AS ca ON a.category_id = ca.id
     LEFT OUTER JOIN techniques AS te ON a.technique_id = te.id
     LEFT OUTER JOIN sizes AS si ON a.size_id = si.id
     LEFT OUTER JOIN size_units AS su ON a.size_unit_id = su.id
     LEFT OUTER JOIN formats AS f ON a.format_id = f.id
     LEFT OUTER JOIN purchases AS p ON p.artwork_id = a.id
       LEFT OUTER JOIN purchase_slips AS ps ON p.purchase_slip_id = ps.id
     LEFT OUTER JOIN trusts AS t ON t.artwork_id = a.id
       LEFT OUTER JOIN trust_slips AS ts ON t.trust_slip_id = ts.id
     LEFT OUTER JOIN consigns AS c ON c.artwork_id = a.id
       LEFT OUTER JOIN consign_slips AS cs ON c.consign_slip_id = cs.id
         LEFT OUTER JOIN customers AS cu ON cs.customer_id = cu.id
     LEFT OUTER JOIN sales AS s ON a.id = s.artwork_id
     LEFT OUTER JOIN images AS i ON a.id = i.artwork_id
     WHERE s.id IS NULL"
     gon.stock_list_data =  Purchase.find_by_sql([sql])

  end

  def search
    sql =
    "SELECT a.id AS id,
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
       CASE WHEN (a.technique_id != 0) AND (te.technique IS NOT NULL)
            THEN te.technique
            ELSE ca.category
       END AS category,
       f.format AS formats,
       CASE WHEN a.retail_price = 0
            THEN NULL
            ELSE a.retail_price
       END AS retail_price,
       CASE WHEN a.wholesale_price = 0
            THEN NULL
            ELSE a.wholesale_price
       END AS wholesale_price,
       CASE WHEN p.price IS NOT NULL
            THEN CASE WHEN p.price = 0
                      THEN NULL
                      ELSE p.price
                 END
            ELSE CASE WHEN t.price = 0
                      THEN NULL
                      ELSE t.price
                 END
      END AS cost,
       CASE WHEN p.price * ps.tax_rate * ps.tax_class_id = 0
            THEN NULL
            ELSE p.price * ps.tax_rate * ps.tax_class_id
       END AS tax,
       cu.name AS customer,
       p.note AS note,
       CASE WHEN c.id IS NOT NULL
            THEN '委託'
            ELSE CASE WHEN t.id IS NOT NULL
                      THEN '受託'
                 END
       END AS status,
       CASE WHEN i.id IS NOT NULL
            THEN '◯'
            ELSE ''
        END image
     FROM artworks AS a
     LEFT OUTER JOIN artists AS at ON a.artist_id = at.id
     LEFT OUTER JOIN categories AS ca ON a.category_id = ca.id
     LEFT OUTER JOIN techniques AS te ON a.technique_id = te.id
     LEFT OUTER JOIN sizes AS si ON a.size_id = si.id
     LEFT OUTER JOIN size_units AS su ON a.size_unit_id = su.id
     LEFT OUTER JOIN formats AS f ON a.format_id = f.id
     LEFT OUTER JOIN purchases AS p ON p.artwork_id = a.id
       LEFT OUTER JOIN purchase_slips AS ps ON p.purchase_slip_id = ps.id
     LEFT OUTER JOIN trusts AS t ON t.artwork_id = a.id
       LEFT OUTER JOIN trust_slips AS ts ON t.trust_slip_id = ts.id
     LEFT OUTER JOIN consigns AS c ON c.artwork_id = a.id
       LEFT OUTER JOIN consign_slips AS cs ON c.consign_slip_id = cs.id
         LEFT OUTER JOIN customers AS cu ON cs.customer_id = cu.id
     LEFT OUTER JOIN sales AS s ON a.id = s.artwork_id
     LEFT OUTER JOIN images AS i ON a.id = i.artwork_id
     WHERE s.id IS NULL
     AND   COALESCE(a.artist_id,0) between :artist_id_from and :artist_id_to
     AND   a.title like :title
     AND   COALESCE(cs.customer_id,0) between :customer_id_from and :customer_id_to
     AND   COALESCE(a.category_id,0) between :category_id_from and :category_id_to
     AND   COALESCE(a.technique_id,0) between :technique_id_from and :technique_id_to
     AND   COALESCE(a.format_id,0) between :format_id_from and :format_id_to"

     if params[:artist_id] == ''
       artist_id_from = 0
       artist_id_to = 999999
     else
       artist_id_from = params[:artist_id]
       artist_id_to = params[:artist_id]
     end

     title = '%' + params[:title] + '%'

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

     @stock_search_data =  Purchase.find_by_sql([sql,{artist_id_from: artist_id_from, artist_id_to: artist_id_to,
                                                         title: title,
                                                         customer_id_from: customer_id_from, customer_id_to: customer_id_to,
                                                         category_id_from: category_id_from, category_id_to: category_id_to,
                                                         technique_id_from: technique_id_from, technique_id_to: technique_id_to,
                                                         format_id_from: format_id_from, format_id_to: format_id_to}])
     render json: @stock_search_data
  end
end
