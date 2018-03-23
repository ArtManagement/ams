class CustomerListsController < ApplicationController
  def index
    @sort = Sort.select(:sort_key, :sort).all
    @customer = Customer.select(:id, "name || '／' || kana AS customer").order(:kana)
    @artist = Artist.select(:id, "name || '／' || kana AS artist").all.order(:kana)
    @category = Category.select(:id, :category).all.order(:id)
    @technique = Technique.select(:id, :technique).all.order(:id)
    @format = Format.select(:id, :format).all.order(:id)
    @warehouse = Warehouse.select(:id, :warehouse).all.order(:id)
    sql =
    "SELECT
      cu.id AS id,
      cu.customer_no,
      cu.kana AS kana,
      cu.name AS name,
      cu.abbreviation AS abbreviation,
      cc.customer_class AS customer_class,
      cu.zip_code AS zip_code,
      pr.prefecture AS prefecture,
      cu.address1 AS address1,
      cu.address2 AS address2,
      cu.tel AS tel,
      cu.fax AS fax
    FROM
      customers AS cu
      LEFT OUTER JOIN customer_classes AS cc
      ON cu.customer_class_id = cc.id
      LEFT OUTER JOIN prefectures AS pr
      ON cu.prefecture_id = pr.id"
    gon.costomer_list_data =  Customer.find_by_sql([sql])

  end
end
