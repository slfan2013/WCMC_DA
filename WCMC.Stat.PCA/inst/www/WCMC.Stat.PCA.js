var myApp = angular.module('myApp', ['ngRoute', 'ui.bootstrap']);

myApp.controller('ctr',function($scope){
  $scope.distance_method = 'euclidean'
  $scope.minkowski_p = 1.5
  $scope.cluster_method = "complete"
  $scope.scale_sample  = true
  $scope.scale_feature  = true
  $scope.row_col = "none"
  $scope.col_col = "none"
  $scope.row_branchColorNumber = 1
  $scope.col_branchColorNumber = 1







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
    $('#output').empty();
    $("#output").html("<p>No output yet.</p>")
    $("#outputpanelheader").addClass("collapsed")
		$("#output").removeClass("in");
		var notready = true;

    var loadSpinner = showSpinner(txt='Computing..');
    var txtinput = $("#rawinput").val().trim();
    var req = ocpu.call("mainApp",{input:txtinput,
    distance_method : $scope.distance_method,
                   minkowski_p : $scope.minkowski_p,
                   cluster_method : $scope.cluster_method,

                   scale_feature : $scope.scale_feature,
                   scale_sample : $scope.scale_sample,

                   row_col : $scope.row_col,
                   row_branchColorNumber : $scope.row_branchColorNumber,

                   col_col : $scope.col_col,
                   col_branchColorNumber : $scope.col_branchColorNumber

    }, function(session) {//calls R function:
			console.log(session);
			view_address = session.loc + "files/PCA.txt"
			download_address = session.loc + "files/PCA&Dendrogram.zip"
		})
		.done(function(){
        $("#outputpanelheader").removeClass("collapsed")
        $("#output").addClass( "in" );
        $("#output").html( "<b style='color:#3C763D;'>Success!</b><br /><div class='well well-sm'><p>NA</p></div><p style='color:grey';'>You can download your result by clicking the Download button.</p><a type='button' href='"+download_address+"' class='btn btn-primary' target='_blank'  download='PCA&Dendrogram.zip'>Download</a>" );
		})
		.fail(function() {
		  $('#output').empty();
      $("#output").html("<p>No output yet.</p>")
      $("#outputpanelheader").addClass("collapsed")
		  $("#output").removeClass("in");
		  alert("Error: " + req.responseText)})
		.always(function(){hideSpinner(loadSpinner);});//ocpu.call
	})


})
$(function(){
$( "#codeToggle" ).click(function() {
  $( "#code" ).toggle( "fast");
});



})
