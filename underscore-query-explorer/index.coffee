$.getJSON "all.json", (data) ->
  window.jsondata = data
  $('h3').after """
  <textarea style="width:100%; height:60px;">
  { "geo.Area.total.quantity": 180 }
  </textarea>
  <button id="filter">Filter</button>
  <span>Your Query:</span>
  <div class="highlight"><pre><code class="javascript" id="query"></code></pre></div>
  <p id="resultSummary"></p>
  <div class="highlight"><pre><code class="javascript" id="resultJSON"></code></pre></div>
  """

  $summary = $('#resultSummary')
  $query = $('#query')
  $json = $('#resultJSON')
  $('#filter').click ->
    query = JSON.parse($('textarea').val())
    $query.html JSON.stringify(query, null, 4)
    hljs.highlightBlock($query[0])
    start = +new Date
    results = _.query data, query
    time = (+new Date) - start
    if results.length
      countries = _.pluck results, "name"
      $summary.html """
        #{results.length} Results Found. #{data.length} countries queried in #{time}ms. <br />
        Countries found: #{countries.join ", "}<br />
        First result below.
      """
      $json.html JSON.stringify results[0], null, 4
      hljs.highlightBlock($json[0])
    else
      $summary.html "No Results Found. #{data.length} countries queried in #{time}ms"
      $json.empty()

