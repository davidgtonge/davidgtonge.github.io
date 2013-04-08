$.getJSON "all.json", (data) ->
  window.jsondata = data
  $('h3').after """
  <textarea style="width:100%; height:60px;">
  { "geo.Area.total.quantity": 180 }
  </textarea>
  <button id="filter">Filter</button>
  <div id="resultSummary"></div>
  <div><pre><code id="resultJSON"></code></pre></div>
  """

  $summary = $('#resultSummary')
  $json = $('#resultJSON')
  $('#filter').click ->
    query = JSON.parse($('textarea').val())
    console.log "running query with", query
    start = +new Date
    results = _.query data, query
    time = (+new Date) - start
    console.log time, results.length
    if results.length
      $summary = "#{results.length} Results Found. #{data.length} countries queried in #{time}ms. First result below."
      $json.html JSON.stringify results[0], null, 2
    else
      $summary = "No Results Found. #{data.length} countries queried in #{time}ms"
      $json.empty()

