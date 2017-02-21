var myApp = angular.module('myApp', ['ngRoute', 'ui.bootstrap']);

myApp.controller('ctr',function($scope){
  $scope.run = function(){
/*
$('#container').highcharts({
        chart       : { type    : 'line', alignTicks: false },
        title       : { text: 'Parallel Coordindates' },
        subtitle    : { text: 'Proof of Concept Using the classic \'cars\' data set' },
        legend      : { enabled : false },
        tooltip     : { enabled : false },
    plotOptions : {
			series : {
				color : 'rgba(204,204,204,.25)',
                events: {
                    mouseOver: function() {
                        this.graph.attr('stroke', 'rgba(0,156,255,1)');
                        this.group.toFront();
                    },
                    mouseOut: function() {
                        this.graph.attr('stroke', 'rgba(204,204,204,0.25)');
                    }
                }
			}
		},
		xAxis  : [{
			opposite: true,
			tickInterval:1,
			lineWidth:0,
			tickWidth:0,
			gridLineWidth:1,
			gridLineColor:'rgba(0,0,0,0.5)',
			gridZIndex: 5,
			labels: {
				y:-17,
				formatter: function() {
					return catsTop[this.value];
				},
				style: {
					fontWeight:'bold'
				}
			}
		},{
			linkedTo:0,
			lineWidth:0,
			tickWidth:0,
			gridLineWidth:0,
			labels: {
                y:10,
				formatter: function() {
					return catsBot[this.value];
				},
				style: {
					fontWeight:'bold'
				}
			}
		}],
		yAxis  : {
			min:0,
			max:100,
			gridLineWidth:0,
            tickWidth:0,
			lineWidth:0,
			labels: {
				enabled: false
			}
		},
       	series : carData
	});
chart = $('#container').highcharts();


function getCarData(cars) {
  var mpgs 	= [];
	var cyls 	= [];
	var dsps 	= [];
	var hps 	= [];
	var lbss 	= [];
	var accs 	= [];
	var years 	= [];
	var mins 	= {};
	var maxs 	= {};
	var ranks 	= {};
	var pData 	= {};

	var mpg = [];
	var cyl= [];
	var dsp= [];
	var hp= [];
	var lbs= [];
	var acc= [];
	var year= [];

	$.each(cars, function(i, car) {
console.log(car);
		if(typeof car.mpg 	!= 'undefined') { mpgs.push(car.mpg		); }
		if(typeof car.cyl 	!= 'undefined') { cyls.push(car.cyl		); }
		if(typeof car.dsp 	!= 'undefined') { dsps.push(car.dsp		); }
		if(typeof car.hp  	!= 'undefined') { hps.push(car.hp		); }
		if(typeof car.lbs 	!= 'undefined') { lbss.push(car.lbs		); }
		if(typeof car.acc 	!= 'undefined') { accs.push(car.acc		); }
		if(typeof car.year 	!= 'undefined') { years.push(car.year	); }

		mpg 	= typeof car.mpg 	!= 'undefined' ? car.mpg 	: null;
		cyl 	= typeof car.cyl 	!= 'undefined' ? car.cyl 	: null;
		dsp 	= typeof car.dsp 	!= 'undefined' ? car.dsp 	: null;
		hp 		= typeof car.hp 	!= 'undefined' ? car.hp 	: null;
		lbs 	= typeof car.lbs 	!= 'undefined' ? car.lbs 	: null;
		acc 	= typeof car.acc 	!= 'undefined' ? car.acc 	: null;
		year 	= typeof car.year 	!= 'undefined' ? car.year 	: null;

		pData[car.name] = [];
		pData[car.name].push(
			{name : 'cyl',  value : cyl },
			{name : 'dsp',  value : dsp },
			{name : 'lbs',  value : lbs },
			{name : 'hp',   value : hp  },
			{name : 'acc',  value : acc },
			{name : 'mpg',  value : mpg },
			{name : 'year', value : year}
		);

	});

	ranks['mpg' ] = percentileRank(mpgs );
	ranks['cyl' ] = percentileRank(cyls );
	ranks['dsp' ] = percentileRank(dsps );
	ranks['hp'  ] = percentileRank(hps  );
	ranks['lbs' ] = percentileRank(lbss );
	ranks['acc' ] = percentileRank(accs, true );
	ranks['year'] = percentileRank(years);

	mins['mpg' ] = Math.min.apply(null, mpgs );
	mins['cyl' ] = Math.min.apply(null, cyls );
	mins['dsp' ] = Math.min.apply(null, dsps );
	mins['hp'  ] = Math.min.apply(null, hps  );
	mins['lbs' ] = Math.min.apply(null, lbss );
	mins['acc' ] = Math.min.apply(null, accs );
	mins['year'] = Math.min.apply(null, years);

	maxs['mpg' ] = Math.max.apply(null, mpgs );
	maxs['cyl' ] = Math.max.apply(null, cyls );
	maxs['dsp' ] = Math.max.apply(null, dsps );
	maxs['hp'  ] = Math.max.apply(null, hps  );
	maxs['lbs' ] = Math.max.apply(null, lbss );
	maxs['acc' ] = Math.max.apply(null, accs );
	maxs['year'] = Math.max.apply(null, years);

	var catsTop = [
		'Cylinders<br/><span style="font-weight:normal;">'+maxs['cyl']+'</span>',
    	'Displacement<br/><span style="font-weight:normal;">'+maxs['dsp']+'</span>',
    	'Lbs<br/><span style="font-weight:normal;">'+maxs['lbs']+'</span>',
        'HP<br/><span style="font-weight:normal;">'+maxs['hp']+'</span>',
        'Acceleration<br/><span style="font-weight:normal;">'+mins['acc']+'</span>',
        'Mpg<br/><span style="font-weight:normal;">'+maxs['mpg']+'</span>',
        'Year<br/><span style="font-weight:normal;">19'+maxs['year']+'</span>'
	];
	var catsBot = [
       	'Cylinders<br/><span style="font-weight:normal;">'+mins['cyl']+'</span>',
        'Displacement<br/><span style="font-weight:normal;">'+mins['dsp']+'</span>',
        'Lbs<br/><span style="font-weight:normal;">'+mins['lbs']+'</span>',
        'HP<br/><span style="font-weight:normal;">'+mins['hp']+'</span>',
        'Acceleration<br/><span style="font-weight:normal;">'+maxs['acc']+'</span>',
        'Mpg<br/><span style="font-weight:normal;">'+mins['mpg']+'</span>',
    	'Year<br/><span style="font-weight:normal;">19'+mins['year']+'</span>'
	];

	var carData = [];
	var i = 0;
	$.each(pData, function(car, measures) {
		carData[i] = {};
		carData[i].name = car;
		carData[i].data = [];
		var val;
		$.each(measures, function() {
			var val = typeof ranks[this.name][this.value] != 'undefined' ? ranks[this.name][this.value] : null;
			carData[i].data.push(val);
		});
		i++;
	});
    rData = {};
    rData.carData = carData;
    rData.catsTop = catsTop;
    rData.catsBot = catsBot;
    return rData;


}
//crude percentile ranking
function percentileRank(data, reverse=false) {
	data.sort(numSort);
	if(reverse === true) {
		data.reverse();
	}
	var len   = data.length;
	var sData = {};
	$.each(data, function(i, point) {
		sData[point] = (i / (len / 100));
	});
	return sData;
}
//because .sort() doesn't sort numbers correctly
function numSort(a,b) {
    return a - b;
}*/








    //$('#output').empty();
    //$("#output").html("<p>No output yet.</p>")
    //$("#outputpanelheader").addClass("collapsed")
		//$("#output").removeClass("in");

    var loadSpinner = showSpinner(txt='Computing..');
    var txtinput = $("#rawinput").val().trim();
    var req = ocpu.call("mainApp",{input:txtinput,center:$('#center').is(':checked'),scale:$('#scale').is(':checked')}, function(session) {//calls R function:
			session.getObject(function(obj){
			  $scope.$apply(function(){
			    //$scope.variance = obj.variance;
			    //$scope.scores = obj.scores;
			    //$scope.loadings = obj.loadings;
			    //$scope.init_pcaPlotData = obj.init_pcaPlotData;
			    $scope.p_names = obj.p_names;
			    $scope.f_names = obj.f_names;
			    $scope.e = obj.e;
			    $scope.f = obj.f;
			    $scope.p = obj.p;
			    $scope.e_Top = obj.e_Top;
			    $scope.e_Bot = obj.e_Bot;
			    $scope.dataframe_e = JSON.parse(obj.dataframe_e);
			    $scope.sampleLessThanFeature = obj.sampleLessThanFeature[0];
			    $scope.ori_nrow = obj.ori_nrow[0];
			  })

			  result = obj; //!!!
			  dataframe_e = $scope.dataframe_e
        pca = $scope.prcomp($scope.e,sampleLessThanFeature=$scope.sampleLessThanFeature,ori_nrow=$scope.ori_nrow) // !!! var
        $scope.scorePlot(pca,p=$scope.p,color=null,xaxisPC=1,yaxisPC=2);


$('#container').highcharts({
        chart       : { type    : 'line', alignTicks: false },
        title       : { text: 'Parallel Coordindates' },
        subtitle    : { text: 'Proof of Concept Using the classic \'cars\' data set' },
        legend      : { enabled : false },
        tooltip     : { enabled : false },
    plotOptions : {
			series : {
				color : 'rgba(204,204,204,.25)',
                events: {
                    mouseOver: function() {
                        this.graph.attr('stroke', 'rgba(0,156,255,1)');
                        this.group.toFront();
                    },
                    mouseOut: function() {
                        this.graph.attr('stroke', 'rgba(204,204,204,0.25)');
                    }
                }
			}
		},
		xAxis  : [{
			opposite: true,
			tickInterval:1,
			lineWidth:0,
			tickWidth:0,
			gridLineWidth:1,
			gridLineColor:'rgba(0,0,0,0.5)',
			gridZIndex: 5,
			labels: {
				y:-17,
				formatter: function() {
					return $scope.e_Top[this.value];
				},
				style: {
					fontWeight:'bold'
				}
			}
		},{
			linkedTo:0,
			lineWidth:0,
			tickWidth:0,
			gridLineWidth:0,
			labels: {
                y:10,
				formatter: function() {
					return $scope.e_Bot[this.value];
				},
				style: {
					fontWeight:'bold'
				}
			}
		}],
		yAxis  : {
			min:0,
			max:100,
			gridLineWidth:0,
            tickWidth:0,
			lineWidth:0,
			labels: {
				enabled: false
			}
		},
       	series : $scope.dataframe_e
	});
  chart2 = $('#container').highcharts();

  			})
  		})
		.done(function(){
        $("#outputpanelheader").removeClass("collapsed")
        $("#output").addClass( "in" );
        //$("#output").html( "<b style='color:#3C763D;'>Success!</b><br /><div class='well well-sm'><p></p></div><a type='button' href='"+file_address+"' class='btn btn-primary' target='_blank'  download='iPCA-normalization.csv'>Download</a>" );
		})
		.fail(function() {
		  //$('#output').empty();
      //$("#output").html("<p>No output yet.</p>")
      //$("#outputpanelheader").addClass("collapsed")
		  //$("#output").removeClass("in");
		  alert("Error: " + req.responseText)})
		.always(function(){hideSpinner(loadSpinner);});//ocpu.call





  }

  $scope.height = 500
  $scope.width = 750
  $scope.xaxisOptions = [1,2,3,4,5]
  $scope.yaxisOptions = [1,2,3,4,5]
  $scope.xaxis = 1
  $scope.yaxis = 2
  $scope.plotType = 'score'





  $scope.prcomp = function(e, sampleLessThanFeature,ori_nrow){ // rows are features and columns are samples.

    var e_t = numeric.transpose(e) // transpose
    var svd = numeric.svd(e_t) // SVD
    //var scores = numeric.dot(svd.U, numeric.diag(svd.S)) // scores.
    //var loadings = svd.V //loadings
    var lambdas = svd.S
    var lambdas_2 = numeric.mul(lambdas,lambdas)
    var cumsum_lambda_2 = lambdas_2.reduce((a,b) => a+b,0)

    var var_exp = [];
    for(var i=0;i<lambdas_2.length;i++){
      var_exp[i] = lambdas_2[i]/cumsum_lambda_2
    }

    var scores = numeric.dot(svd.U, numeric.diag(svd.S));
    var loadings = svd.V;
    var var_exp = var_exp;

    if(sampleLessThanFeature){ //numeric.js cannot deal with n<p problem. Have to do some trick.
        scores = scores.slice(0,ori_nrow)
        loadings = numeric.transpose(numeric.transpose(loadings).slice(0,ori_nrow))
        var_exp = var_exp.slice(0,ori_nrow)
    }

    var result = {
      scores:scores, // scores.
      loadings:loadings,//loadings
      var_exp:var_exp //variance explained
    }

    ooo = result;

    return result;
  }


  $scope.scorePlot = function(pca,p,color = null, xaxisPC = 1, yaxisPC = 2){
    if(color===null){
        var series = [{name: 'samples',
                  color: 'rgba(0,0,0,1)',
                  data:[]
                 }]
        for(var i=0;i<p.length;i++){
          series[0].data.push(
            [pca.scores[i][xaxisPC],pca.scores[i][yaxisPC]]
          )
        }
    }else{
        var series = [];
        var distinct_color_groups = [];
        var unique = {};


        for(var i in p){
          if( typeof(unique[p[i][color]]) == "undefined"){
            distinct_color_groups.push(p[i][color]);
          }
          unique[p[i][color]] = 0;
        }


        var num_colors = distinct_color_groups.length
        if(num_colors>12){
          var colors = palette('tol-rainbow', num_colors);
        }else{
          var colors = palette('tol', num_colors);
        }
        for(var i=0;i<num_colors;i++){
          series[i] = {
            name : distinct_color_groups[i],
            color : '#'+colors[i],
            marker:{symbol:'circle'},
            data : []
          }
        }
        for(var i=0;i<p.length;i++){
         var index = $.inArray(p[i][color], distinct_color_groups)
         series[index].data.push(
           [pca.scores[i][xaxisPC],pca.scores[i][yaxisPC]]
         )
        }
    }


   chart = Highcharts.chart('score',{
                  chart: {
                            type: 'scatter',
                            zoomType: 'xy',
                            style: {
                              fontFamily: 'serif'
                            }
                          },
                  title: {
                      text: 'PCA Score Plot'
                  },
                  subtitle: {
                            text: 'PC'+xaxisPC + '  vs ' + 'PC'+yaxisPC
                        },
                  xAxis: {
                      title: {
                          enabled: true,
                          text: "PC"+xaxisPC+" ("+(pca.var_exp[xaxisPC-1]*100).toFixed(2)+"%)"
                      },
                      startOnTick: true,
                      endOnTick: true
                  },
                  yAxis: {
                      title: {
                          enabled: true,
                          text: "PC"+yaxisPC+" ("+(pca.var_exp[yaxisPC-1]*100).toFixed(2)+"%)"
                      },
                      startOnTick: true,
                      endOnTick: true
                  },
                  legend: {
                    enabled: num_colors<=12,
                    layout: 'horizontal',
                    align: 'center',
                    backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
                  },
                  plotOptions: {
                    scatter: {
                        marker: {
                            radius: 5,
                            states: {
                                hover: {
                                    enabled: true,
                                    lineColor: 'rgb(100,100,100)'
                                }
                            }
                        },
                        states: {
                            hover: {
                                marker: {
                                    enabled: false
                                }
                            }
                        },
                        tooltip: {
                            headerFormat: '<b>{series.name}</b><br>',
                            pointFormat: '{point.x:.2f} @PC'+xaxisPC+', {point.y:.2f} @PC'+yaxisPC
                        }
                    }
                  },
                  series: series
                })



  }


  $scope.dataRelatedUpdate = function(){
    $scope.scorePlot(pca,p=$scope.p,color=$scope.color,xaxisPC=$scope.xaxis,yaxisPC=$scope.yaxis);
  }

})





$(function(){
$( "#codeToggle" ).click(function() {
  $( "#code" ).toggle( "fast");
});




})
