var myApp = angular.module('myApp', ['ngRoute', 'ui.bootstrap']);

myApp.controller('ctr',function($scope){
  $scope.power = '1/3'


  	$("#compute").click(function(){
    $('#output').empty();
    $("#output").html("<p>No output yet.</p>")
    $("#outputpanelheader").addClass("collapsed")
		$("#output").removeClass("in");
		var notready = true;

    var loadSpinner = showSpinner(txt='Computing..');
    var txtinput = $("#rawinput").val().trim();
    var req = ocpu.call("mainApp",{input:txtinput,power:$scope.power}, function(session) {//calls R function:
			console.log(session);
			view_address = session.loc + "files/Power-normalization.txt"
			download_address = session.loc + "files/Power-normalization.csv"
		})
		.done(function(){
        $("#outputpanelheader").removeClass("collapsed")
        $("#output").addClass( "in" );
        $("#output").html( "<b style='color:#3C763D;'>Success!</b><br /><div class='well well-sm'></div><p style='color:grey';'>You can either view your normalized result <a href='"+view_address+"' target='_blank'>here</a>, or download your result by clicking the Download button.</p><a type='button' href='"+download_address+"' class='btn btn-primary' target='_blank'  download='Power-normalization.csv'>Download</a>" );
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
