var myApp = angular.module('myApp', ['ngRoute', 'ui.bootstrap']);

myApp.controller('ctr',function($scope){

  $scope.center = true
  $scope.scale = true
  $scope.contribute_axes = 1
  $scope.xaxis = "1"
  $scope.yaxis = "2"
  $scope.contribute_axes = "1"
  $scope.num_of_var = 15

  $scope.plotType = 'Scree'








$('#rawinput').on('blur',function() {
  var txtinput = $("#rawinput").val().trim();
  var req = ocpu.call("secondApp",{input:txtinput}, function(session) {//This function is designed for the column names of p and f.
    session.getObject(function(obj){
      $scope.$apply(function(){
        $scope.colnames_p = obj.colnames_p
        $scope.colnames_f = obj.colnames_f
      })
    })
  })
});




	$("#compute").click(function(){
    $('#text').empty();
    $("#text").html("<p>No output yet.</p>")
    $("#outputpanelheader").addClass("collapsed")
		$("#output").removeClass("in");
		var notready = true;

    var loadSpinner = showSpinner(txt='Computing..');
    var txtinput = $("#rawinput").val().trim();
    var req = ocpu.call("mainApp",{input:txtinput,
                   center:$scope.center,
                   scale : $scope.scale,
                   score_axis : [$scope.xaxis,$scope.yaxis],
                   color : $scope.row_col,

                   num_of_var : $scope.num_of_var,
                   contribute_axes:$scope.contribute_axes

    }, function(session) {//calls R function:
			console.log(session);
			$scope.$apply(function(){
			  $scope.session = session.loc
			})
			view_address = session.loc + "files/PCA.txt"
			download_address = session.loc + "files/PCA.zip"
		})
		.done(function(){
        $("#outputpanelheader").removeClass("collapsed")
        $("#output").addClass( "in" );
        $("#text").html( "<b style='color:#3C763D;'>Success!</b><br /><div class='well well-sm'><p>NA</p></div><p style='color:grey';'>You can download your result by clicking the Download button.</p><a type='button' href='"+download_address+"' class='btn btn-primary' target='_blank'  download='PCA&Dendrogram.zip'>Download</a>" );
		})
		.fail(function() {
		  $('#output').empty();
      $("#text").html("<p>No output yet.</p>")
      $("#outputpanelheader").addClass("collapsed")
		  $("#output").removeClass("in");
		  alert("Error: " + req.responseText)})
		.always(function(){hideSpinner(loadSpinner);});//ocpu.call
	})


})
$(function(){var loadSpinner = showSpinner(txt='Computing..');var install= ocpu.call("install",{force:false},function(session){console.log(session)}).always(function(){hideSpinner(loadSpinner)});


$( "#codeToggle" ).click(function() {
  $( "#code" ).toggle( "fast");
});



})
