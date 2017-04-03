var myApp = angular.module('myApp', ['ngRoute', 'ui.bootstrap']);

myApp.controller('ctr',function($scope){
  $scope.type = 'sum'
})
$(function(){
$( "#codeToggle" ).click(function() {
  $( "#code" ).toggle( "fast");
});

	$("#compute").click(function(){
    $('#output').empty();
    $("#output").html("<p>No output yet.</p>")
    $("#outputpanelheader").addClass("collapsed")
		$("#output").removeClass("in");
		var notready = true;

    var loadSpinner = showSpinner(txt='Computing..');
    var txtinput = $("#rawinput").val().trim();
    var req = ocpu.call("mainApp",{input:txtinput}, function(session) {//calls R function:
			console.log(session);
			view_address = session.loc + "files/TwoWayMixedANOVA.txt"
			download_address = session.loc + "files/TwoWayMixedANOVA.csv"
		})
		.done(function(){
        $("#outputpanelheader").removeClass("collapsed")
        $("#output").addClass( "in" );
        $("#output").html( "<b style='color:#3C763D;'>Success!</b><br /><div class='well well-sm'><p>NA</p></div><div class='well well-sm'><p><b>A*B:</b> the raw p value of interaction effect of A and B, calculated by two-way ANOVA.</p><p><b>ANOVA (A):</b> the p value of the main effect of A, calculated by one-way Welch ANOVA.</p><p><b>ANOVA (A) @b:</b> the p value of the simple main effect of A at the level b of B, calculated by one-way Welch ANOVA.</p><p><b>a1 vs a2 @b:</b> the raw p value of the post hoc analysis of a1 vs a2 at the level b of B, calculated either by (paired) t test or Games-Howell test or paired t test with Holm (1997) FDR procedure depending on the number of levels and the dependency of A.</p><p><b>a1 vs a2 @b (FDR):</b> the adjusted p value of the raw p value (if available).</p></div><p style='color:grey';'>You can either view your normalized result <a href='"+view_address+"' target='_blank'>here</a>, or download your result by clicking the Download button.</p><a type='button' href='"+download_address+"' class='btn btn-primary' target='_blank'  download='TwoWayMixedANOVA.csv'>Download</a>" );
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
