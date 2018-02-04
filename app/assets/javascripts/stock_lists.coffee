# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  stock_list_data = gon.stock_list_data
  $('#stock_list').jqGrid
    styleUI: 'Bootstrap'
    datatype: 'local'
    data: stock_list_data
    editurl: 'clientArray'
    colNames: ['作品No', '作家', 'タイトル', 'ＥＤ・号数', '分類・技法', '体裁', '画像', '状況', '委託先・倉庫', '上代', '下代','コスト','消費税', '備考', '作品ID']
    colModel: [ { name:'artwork_no', width: 85, sortable: false}
                { name:'artist', width: 160, sortable: false }
                { name:'title', width: 240, sortable: false }
                { name:'size', width: 120, sortable: false }
                { name:'category', width: 160, sortable: false }
                { name:'formats', width: 80, sortable: false }
                { name:'image', width: 70, sortable: false }
                { name:'status', width: 70, sortable: false }
                { name:'customer', width: 200, sortable: false }
                { name:'retail_price', width: 100, sortable: false, align : 'right', formatter: 'number',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'wholesale_price', width: 100, sortable: false, align : 'right', formatter: 'number',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'cost', width: 100, sortable: false, align : 'right', formatter: 'number',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'tax', width: 100, sortable: false, align : 'right', formatter: 'number',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'note', width: 200, sortable: false }
                { name:'id', width: 0, hidden: true } ]
    loadComplete: ->
      artwork_cnt = $('#stock_list').jqGrid 'getCol', 'id', false, 'count'
      price_sum = $('#stock_list').jqGrid 'getCol', 'cost', false, 'sum'
      tax_sum = $('#stock_list').jqGrid 'getCol', 'tax', false, 'sum'
      t = document.getElementById('stock_list_sum')
      t.rows[1].cells[0].innerHTML = artwork_cnt.toLocaleString()
      t.rows[1].cells[1].innerHTML = price_sum.toLocaleString()
      t.rows[1].cells[2].innerHTML = tax_sum.toLocaleString()
      t.rows[1].cells[3].innerHTML = (price_sum + tax_sum).toLocaleString()
    multiselect: false
    autoencode: true
    cellEdit: true
    cellsubmit: 'clientArray'
    width: 1140
    height: 475
    shrinkToFit: false
    rowNum: 200
    loadonce: true
    viewrecords: true
    caption:''

# 作品詳細ボタン
  $('#stock_list_artwork').click ->
    id = $("#stock_list").jqGrid('getGridParam','selrow')
    ret = $("#stock_list").jqGrid('getRowData',id)
    if ret.id
      window.open('/artworks/' + ret.id,'', 'height=600, width=1200')

# 検索ボタン
  $('#stock_lists_search').click ->
    artist_id = document.getElementById('stock_lists_artist_id').value
    title = document.getElementById('stock_lists_title').value
    customer_id = document.getElementById('stock_lists_customer_id').value
    category_id = document.getElementById('stock_lists_category_id').value
    technique_id = document.getElementById('stock_lists_technique_id').value
    format_id = document.getElementById('stock_lists_format_id').value
    $.ajax
      type: 'GET'
      url: '/stock_lists/search'
      async: false
      datatype: 'json'
      data: artist_id: artist_id, title: title, customer_id: customer_id,
      category_id: category_id, technique_id: technique_id, format_id: format_id
      success: (stock_search_data)->
        $("#stock_list").clearGridData()
        stock_list_data = stock_search_data
        $('#stock_list').jqGrid('setGridParam', {datatype: 'local',data: stock_list_data}).trigger('reloadGrid')
      error:　-> alert("サーバーとの通信に失敗しました。")
