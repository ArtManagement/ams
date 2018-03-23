# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  customer_list_data = gon.customer_list_data
  $('#customer_list').jqGrid
    styleUI: 'Bootstrap4'
    iconSet: 'fontAwesome'
    datatype: 'local'
    data: customer_list_data
    editurl: 'clientArray'
    colNames: ['id', '顧客No', '顧客名', '顧客カナ', '顧客略称', '顧客区分', '郵便番号', '都道府県', '住所１', '住所２', 'TEL', 'FAX']
    colModel: [ { name:'id', width: 0, hidden: true }
                { name:'customer_no', width: 85, sortable: false}
                { name:'name', width: 140, sortable: false }
                { name:'kana', width: 200, sortable: false }
                { name:'abbreviation', width: 110, sortable: false }
                { name:'customer_class', width: 120, sortable: false }
                { name:'zip_cade', width: 70, sortable: false }
                { name:'prefecture', width: 70, sortable: false }
                { name:'adress1', width: 200, sortable: false }
                { name:'adress2', width: 200, sortable: false }
                { name:'tel', width: 200, sortable: false }
                { name:'fax', width: 200, sortable: false } ]
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
