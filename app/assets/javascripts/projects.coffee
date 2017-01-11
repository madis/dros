document.addEventListener 'turbolinks:load', (event) ->
  $('.project-health-chart').each ->
    chartOptions =
      lineSmooth: Chartist.Interpolation.cardinal tension: 0
      low: 0
      high: 110
      chartPadding: { top: 0, right: 0, bottom: 0, left: 0}
    chartData = $(@).data('values')
    new Chartist.Line(@, chartData)
