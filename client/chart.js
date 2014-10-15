this.drawChart = function() {
  var chart = document.getElementById('chart');

  if (chart !== undefined && chart !== null) {
    var pollData = Options.find({'pollId': Session.get('pollId')},
      {fields: {'votes': 1, 'text': 1}}).fetch();

    var data = [];

    _.each(pollData, function(element, index) {
      data.push({
        value: element.votes,
        label: element.text,
        color: '#' + colors[index]
      });
    });

    var ctx = chart.getContext('2d');
    var myPieChart = new Chart(ctx).Pie(data, chartOptions);
  }
};

var chartOptions = {
  segmentShowStroke: true,
  segmentStrokeColor: '#fff',
  segmentStrokeWidth: 2,
  animation: false,
  animationSteps: 60,
  animationEasing: 'easeOutQuart',
};

var colors = ['F7464A', '46BFBD', 'FDB45C', '9B72BF', '72BF9E', 'BF72A4'];
