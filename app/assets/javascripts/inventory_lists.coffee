# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  inventory_list_data = gon.inventory_list_data
  $('#inventory_list').jqGrid
    styleUI: 'Bootstrap4'
    datatype: 'local'
    data: inventory_list_data
    editurl: 'clientArray'
    iconSet: 'fontAwesome'
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
      artwork_cnt = $('#inventory_list').jqGrid 'getCol', 'id', false, 'count'
      price_sum = $('#inventory_list').jqGrid 'getCol', 'cost', false, 'sum'
      tax_sum = $('#inventory_list').jqGrid 'getCol', 'tax', false, 'sum'
      t = document.getElementById('inventory_list_sum')
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
  $('#inventory_list_artwork').click ->
    id = $("#inventory_list").jqGrid('getGridParam','selrow')
    ret = $("#inventory_list").jqGrid('getRowData',id)
    if ret.id
      window.open('/artworks/' + ret.id,'', 'height=600, width=1200')

# 検索ボタン
  $('#inventory_lists_search').click ->
    artist_id = document.getElementById('inventory_lists_artist_id').value
    title = document.getElementById('inventory_lists_title').value
    customer_id = document.getElementById('inventory_lists_customer_id').value
    category_id = document.getElementById('inventory_lists_category_id').value
    technique_id = document.getElementById('inventory_lists_technique_id').value
    format_id = document.getElementById('inventory_lists_format_id').value
    $.ajax
      type: 'GET'
      url: '/inventory_lists/search'
      async: false
      datatype: 'json'
      data: artist_id: artist_id, title: title, customer_id: customer_id,
      category_id: category_id, technique_id: technique_id, format_id: format_id
      success: (inventory_search_data)->
        $("#inventory_list").clearGridData()
        inventory_list_data = inventory_search_data
        $('#inventory_list').jqGrid('setGridParam', {datatype: 'local',data: inventory_list_data}).trigger('reloadGrid')
      error:　-> alert("サーバーとの通信に失敗しました。")
