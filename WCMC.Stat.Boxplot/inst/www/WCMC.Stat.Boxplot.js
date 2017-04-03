var myApp = angular.module('myApp', ['ngRoute', 'ui.bootstrap']);

myApp.controller('ctr',function($scope){


$scope.twoway = "true"
$scope.legend_position = "topleft"
$scope.jitter = true

$scope.getFactorOrder = function(){
  var txtinput = $("#rawinput").val().trim();
  var req = ocpu.call("secondApp",{input:txtinput, twoway : $scope.twoway}, function(session) {//for factor_order1 and factor_order2
  console.log(session)
    session.getObject(function(obj){
      $scope.$apply(function(){
        $scope.factor_order1 = obj.factor_order1
        $scope.factor_order2 = obj.factor_order2
        $scope.compoundNames = obj.compoundNames
        $scope.compoundName = obj.compoundNames[0]
        var colors = []
        for (var i = 0; i < obj.colors.length; i++) {
          colors.push(obj.colors[i].toLowerCase());
        }
        $scope.colors = colors
        console.log($scope.colors)
      })
    })
  })
}




$('#rawinput').on('blur click',function() {
  $scope.getFactorOrder()
});


$("#download_all").on("click",function(){

  var loadSpinner = showSpinner(txt='Computing..');
  var txtinput = $("#rawinput").val().trim();
  var req = ocpu.call("mainApp",{input:txtinput,
    twoway : $scope.twoway,
                   factor_order1 : $scope.factor_order1, factor_order2 : $scope.factor_order2,
                   legend_position : $scope.legend_position,
                   draw_single : false,compoundName : $scope.compoundName,
                   colors:$scope.colors

    },function(session){
      console.log(session)
      download_all_address = session.loc +"files/Boxplots.zip"
    }).done(function(){
      window.open(download_all_address)
    }).always(function(){hideSpinner(loadSpinner);});//ocpu.call
})



	$("#compute").click(function(){

	  var col = document.getElementsByClassName("boxplotColors");
	  var colors = []
	  for (var i = 0; i < col.length; i++) {
          colors.push(col[i].value.toUpperCase());
        }
    $scope.colors = colors

    console.log($scope.colors)

    $('#outputtext').empty();
    $("#outputtext").html("<p>No output yet.</p>");
    $("#outputpanelheader").addClass("collapsed");
		$("#output").removeClass("in");

		var notready = true;
    var loadSpinner = showSpinner(txt='Computing..');
    var txtinput = $("#rawinput").val().trim();
    /*var req = $("#individual_boxplot").rplot("mainApp",{input:txtinput,
    twoway : $scope.twoway,
                   factor_order1:$scope.factor_order1, factor_order2:$scope.factor_order2,
                   legend_position:$scope.legend_position,
                   draw_single:true,compoundName:$scope.compoundName,
                   jitter: true
    })*/
    var req = ocpu.call("mainApp",{input:txtinput,
    twoway : $scope.twoway,
                   factor_order1:$scope.factor_order1, factor_order2:$scope.factor_order2,
                   legend_position:$scope.legend_position,
                   draw_single:true,compoundName:$scope.compoundName,
                   jitter: true,colors:$scope.colors
    },function(session){
      console.log(session.loc)
      session.getObject(function(obj){
        $scope.$apply(function(){
          $scope.session = session.loc
        })
      })
    })
		.done(function(){
        $("#outputpanelheader").removeClass("collapsed")
        $("#output").addClass("in");
        $scope.$apply(function(){
            $scope.success = true;
        })
        $("#outputtext").html( "<b style='color:#3C763D;'>Success!</b><br /><div class='well well-sm'></div><p style='color:grey';'>You could make boxplots for every compound and download them by clicking the Download_all_boxplots button.</p>" );
		})
		.fail(function() {
		  $('#outputtext').empty();
      $("#outputtext").html("<p>No output yet.</p>")
      $("#outputpanelheader").addClass("collapsed")
		  $("#output").removeClass("in");
		      $scope.$apply(function(){
        $scope.success = false;
    })
		  alert("Error: " + req.responseText)})
		.always(function(){hideSpinner(loadSpinner);});//ocpu.call
	})


})
$(function(){
$( "#codeToggle" ).click(function() {
  $( "#code" ).toggle( "fast");
});



})
