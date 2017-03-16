var myApp = angular.module('myApp', ['ngRoute', 'ui.bootstrap']);

myApp.controller('ctr',function($scope){


  $scope.pvaluecrit = 0.1
  $scope.foldchangecrit = 1.2

  $("#compute").click(function(){
    $('#output_text').empty();
    $("#output_text").html("<p>No output yet.</p>")
    $("#outputpanelheader").addClass("collapsed")
		$("#output").removeClass("in");
		var notready = true;

    var loadSpinner = showSpinner(txt='Computing..');
    var txtinput = $("#rawinput").val().trim();
    var req = ocpu.call("mainApp",{input:txtinput, pvaluecrit:$scope.pvaluecrit,foldchangecrit:$scope.foldchangecrit}, function(session) {//calls R function:
			console.log(session);
			$scope.$apply(function(){
			  $scope.plotAddress = session.loc + "files/VolcanoPlot.png"
			})
			download_address = session.loc + "files/VolcanoPlot.png"
		})
		.done(function(){
        $("#outputpanelheader").removeClass("collapsed")
        $("#output").addClass( "in" );
        $("#output_text").html( "<b style='color:#3C763D;'>Success!</b><br /><div class='well well-sm'><p>NA</p></div><p style='color:grey';'>You can download your result by clicking the Download button.</p><a type='button' href='"+download_address+"' class='btn btn-primary' target='_blank'  download='VolcanoPlot.png'>Download</a>" );
		})
		.fail(function() {
		  $('#output').empty();
      $("#output_text").html("<p>No output yet.</p>")
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
