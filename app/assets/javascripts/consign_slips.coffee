# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  consign_data = gon.consign_data
  consign_artwork_id = gon.consign_artwork_id
  $('#consign_slip').jqGrid
    styleUI: 'Bootstrap4'
    iconSet: 'fontAwesome'
    datatype: 'local'
    data: consign_data
    editurl: 'clientArray'
    colNames: [ '', '作品No', '作家名', 'タイトル', 'ＥＤ・号数', '分類・技法', '体裁', '状況', '委託価格', '上代', '下代', '原価', '備考', 'id', '作品ID']
    colModel: [ { name:'actions', width: 60, formatter: "actions", formatoptions: {keys: false,editbutton: false, delbutton: true, delOptions: {}}}
                { name:'artwork_no', width: 100, editable: true, sortable: false, edittype: "select",
                editoptions: { value: consign_artwork_id , dataInit: (artwork_id) -> $(artwork_id).select2 theme: "bootstrap", dropdownAutoWidth: true,  width: "1080px" } }
                { name:'name', width: 180, sortable: false }
                { name:'title', width: 240, sortable: false }
                { name:'size', width: 100, sortable: false }
                { name:'category', width: 160, sortable: false }
                { name:'format', width: 80, sortable: false }
                { name:'status', width: 80, sortable: false }
                { name:'price', width: 120, editable: true, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'retail_price', width: 100, sortable: false, align : 'right', formatter: 'number',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' }}
                { name:'wholesale_price', width: 100, sortable: false, align : 'right', formatter: 'number',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' }}
                { name:'cost', width: 100, sortable: false, align : 'right', formatter: 'number',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' }}
                { name:'note', width: 200, sortable: false, editable: true, edittype: "textarea"}
                { name:'id', width: 0,hidden : true }
                { name:'artwork_id', width: 0,hidden : true } ]
    beforeEditCell: ( rowid, cellname, value, iRow, iCol ) ->
      if cellname == 'artwork_no'
        ret = $("#consign_slip").jqGrid('getRowData',rowid)
        tmp = ret.artwork_no
    afterSaveCell: ( rowid, cellname, value, iRow, iCol ) ->
      if cellname == 'artwork_no'
        ret = $("#consign_slip").jqGrid('getRowData',rowid)
        if ret.artwork_no != ''
          $.ajax
            type: 'GET'
            url: '/consign_slips/artworkGet'
            async: false
            datatype: 'json'
            data: consign_id: ret.id, artwork_id: value, price: ret.price, note: ret.note, consign_slip_id: $('#consign_slip_id').val()
            success: (artwork_data) ->
              ret.artwork_no = artwork_data[0].artwork_no
              ret.name = artwork_data[0].name
              ret.title = artwork_data[0].title
              ret.category = artwork_data[0].category
              $("#consign_slip").jqGrid('setRowData',rowid,ret)
          if value != 0 and ret.artwork_id == ""
            $('#consign_slip').addRowData undefined,{artwork_id:'',price:''}
      if cellname == 'price'
        ret = $("#consign_slip").jqGrid('getRowData',rowid)
        if ret.id != null
          $.ajax
            type: 'GET'
            url: '/consign_slips/priceSet'
            async: false
            datatype: 'json'
            data: consign_id: ret.id, price: value, note: ret.note
    loadComplete: ->
      $('#consign_slip').addRowData undefined,{artwork_id:'',price:''}
      artwork_cnt = ($('#consign_slip').jqGrid 'getCol', 'id', false, 'count') - 1
      price_sum = $('#consign_slip').jqGrid 'getCol', 'price', false, 'sum'
      tax_sum = parseInt(($('#consign_slip').jqGrid 'getCol', 'price', false, 'sum' ) * $('#consign_slip_tax_class_id').val() * $('#consign_slip_tax_rate').val())
      price_total = price_sum + tax_sum
      t = document.getElementById('consign_sum')
      t.rows[1].cells[0].innerHTML = artwork_cnt.toLocaleString()
      t.rows[1].cells[1].innerHTML = price_sum.toLocaleString()
      t.rows[1].cells[2].innerHTML = tax_sum.toLocaleString()
      t.rows[1].cells[3].innerHTML = price_total.toLocaleString()

    multiselect: false
    autoencode: true
    cellEdit: true
    cellsubmit: 'clientArray'
    width: 1135
    height: 385
    shrinkToFit: false
    rowNum: 200
    sortname: 'id'
    loadonce: true
    viewrecords: true
    sortorder: 'asc'
    caption:''
#    pager: '#consign_slip_pager'

#  $('#consign_slip').navGrid '#consign_slip_pager',{ edit: false, add: false, del: true, search: false, refresh: false, view: false, position: "left", cloneToTop: false }

# 参照ボタン
  $('#consign_slip_refer').click ->
    if $("#consign_slip_id").val()
      window.open('/consign_references/?slip_id=' + $("#consign_slip_id").val(),'', 'height=640, width=1200')

# 新規伝票ボタン
  $('#consign_slip_new').click ->
    location.href = '/consign_slips/new'

# 作品登録ボタン
  $('#consign_slip_artwork').click ->
    if $("#consign_slip_id").val()
      id = $("#consign_slip").jqGrid('getGridParam','selrow')
      ret = $("#consign_slip").jqGrid('getRowData',id)
      if ret.artwork_id
        window.open('/artworks/' + ret.artwork_id,'', 'height=560, width=1200')

# 伝票No変更
  $('#consign_slip_id').change ->
    location.href = '/consign_slips/' + $('#consign_slip_id').val()
