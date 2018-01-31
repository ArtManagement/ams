class PurchaseSlipPDF

  # Classメソッドを定義
  def self.create purchase_slip
    # Thin ReportsでPDFを作成
    # 先ほどEditorで作ったtlfファイルを読み込む
    report = Thinreports::Report.new :layout => "app/pdfs/purchase_slip.tlf"

    # 1ページ目を開始
    report.start_new_page

    # 注文番号と注文日の値を設定
    # itemメソッドでtlfファイルのIDを指定し、
    # valueメソッドで値を設定します
    #report.page.item(:order_id).value(order.id)
    #report.page.item(:purchased_at).value(order.purchased_at)

    # ThinReports::Reportを返す
    return report
  end
end
