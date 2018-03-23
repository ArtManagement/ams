# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  sale_reference = gon.sale_reference
  $('#sale_reference').jqGrid
    styleUI: 'Bootstrap4'
    iconSet: 'fontAwesome'
    datatype: 'local'
    data: sale_reference
    editurl: 'clientArray'
    colNames: ['作品No', '作家', 'タイトル', 'ＥＤ・号数', '分類・技法', '体裁', '仕入価格', '消費税', '作品ID']
    colModel: [ { name:'artwork_no', width: 85, sortable: false}
                { name:'artist', width: 140, sortable: false }
                { name:'title', width: 220, sortable: false }
                { name:'size', width: 100, sortable: false }
                { name:'category', width: 140, sortable: false }
                { name:'formats', width: 60, sortable: false }
                { name:'purchase_price', width: 110, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'purchase_tax', width: 100, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'id', width: 0, hidden: true }]
    multiselect: false
    autoencode: true
    cellEdit: true
    cellsubmit: 'clientArray'
    width: 1070
    height: 385
    shrinkToFit: false
    rowNum: 200
    loadonce: true
    viewrecords: true
    caption:''

# 作品登録ボタン
  $('#sale_reference_artwork').click ->
    id = $("#sale_reference").jqGrid('getGridParam','selrow')
    ret = $("#sale_reference").jqGrid('getRowData',id)
    if ret.id
      window.open('/artworks/' + ret.id,'', 'height=560, width=1200')

# 検索ボタン
  $('#sale_references_search').click ->
    artist_id = document.getElementById('sale_references_artist_id').value
    title = document.getElementById('sale_references_title').value
    category_id = document.getElementById('sale_references_category_id').value
    technique_id = document.getElementById('sale_references_technique_id').value
    format_id = document.getElementById('sale_references_format_id').value
    $.ajax
      type: 'GET'
      url: '/sale_references/search'
      async: false
      datatype: 'json'
      data: artist_id: artist_id, title: title, category_id: category_id, technique_id: technique_id, format_id: format_id
      success: (sale_reference_search)->
        $("#sale_reference").clearGridData()
        $('#sale_reference').jqGrid('setGridParam', {datatype: 'local',data: sale_reference_search}).trigger('reloadGrid')
      error:　-> alert("サーバーとの通信に失敗しました。")

# 選択ボタン
  $('#sale_reference_select').click ->
    artist_id = document.getElementById('sale_references_artist_id').value
    title = document.getElementById('sale_references_title').value
    category_id = document.getElementById('sale_references_category_id').value
    technique_id = document.getElementById('sale_references_technique_id').value
    format_id = document.getElementById('sale_references_format_id').value
    id = $("#sale_reference").jqGrid('getGridParam','selrow')
    slip_id = location.search.slice(9)
    ret = $("#sale_reference").jqGrid('getRowData',id)
    if ret.id
      $.ajax
        type: 'GET'
        url: '/sale_references/select'
        async: false
        datatype: 'json'
        data: slip_id: slip_id, artwork_id: ret.id, artist_id: artist_id, title: title, category_id: category_id, technique_id: technique_id, format_id: format_id
        success: (sale_reference_search)->
          $("#sale_reference").clearGridData()
          $('#sale_reference').jqGrid('setGridParam', {datatype: 'local',data: sale_reference_search}).trigger('reloadGrid')
        error:　-> alert("サーバーとの通信に失敗しました。")
