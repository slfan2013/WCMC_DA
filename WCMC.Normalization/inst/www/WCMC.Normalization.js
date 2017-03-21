var myApp = angular.module('myApp', ['ngRoute', 'ui.bootstrap']);

myApp.controller('ctr',function($scope){

   $scope.normalizationMethods = ["None","mTIC","SampleSpecific","Quantile","PQN","contrast","batch","loess"].sort();
   $scope.normalizationMethodsSelection = ["None","mTIC","SampleSpecific","Quantile","PQN","contrast","batch","loess"].sort();
   $scope.sampleSpecificMethods = ['sum','median','mean','custom sample weight']
   $scope.sampleSpecificMethodsSelection = ['sum','median','mean']
   $scope.transformationMethods = ['None','log','power'].sort()
   $scope.transformationMethodsSelection = ['None','log','power'].sort()
   $scope.logbase = 'exp(1)'
   $scope.power = '1/3'
   $scope.scaleMethods = ["None","centering","auto",'parato','vast','level','range']
   $scope.scaleMethodsSelection = ["None","centering","auto",'parato','vast','level','range']
   $scope.PCA = true
   $scope.Normality = true
   $scope.RSD = true
   $scope.plotType = "RSD"
   $scope.autoSpan = false

  $scope.togglenormalizationMethodsSelection = function(normalizationMethod) {
      var idx = $scope.normalizationMethodsSelection.sort().indexOf(normalizationMethod);
      if (idx > -1) {
        $scope.normalizationMethodsSelection.sort().splice(idx, 1);
      }
      else {
        $scope.normalizationMethodsSelection.sort().push(normalizationMethod);
      }
    };
  $scope.togglesampleSpecificMethodsSelection = function(sampleSpecificMethod) {
      var idx = $scope.sampleSpecificMethodsSelection.sort().indexOf(sampleSpecificMethod);
      if (idx > -1) {
        $scope.sampleSpecificMethodsSelection.sort().splice(idx, 1);
      }
      else {
        $scope.sampleSpecificMethodsSelection.sort().push(sampleSpecificMethod);
      }
    };
  $scope.toggletransformationMethodsSelection = function(transformationMethod) {
      var idx = $scope.transformationMethodsSelection.sort().indexOf(transformationMethod);
      if (idx > -1) {
        $scope.transformationMethodsSelection.sort().splice(idx, 1);
      }
      else {
        $scope.transformationMethodsSelection.sort().push(transformationMethod);
      }
    };
  $scope.togglescaleMethodsSelection = function(scaleMethod) {
    var idx = $scope.scaleMethodsSelection.sort().indexOf(scaleMethod);
    if (idx > -1) {
      $scope.scaleMethodsSelection.sort().splice(idx, 1);
    }
    else {
      $scope.scaleMethodsSelection.sort().push(scaleMethod);
    }
  };






  $("#compute").click(function(){
    $('#outputText').empty();
    $("#outputText").html("<p>No output yet.</p>")
    $("#outputpanelheader").addClass("collapsed")
		$("#output").removeClass("in");
		var notready = true;

    var loadSpinner = showSpinner(txt='Computing..');
    var txtinput = $("#rawinput").val().trim();
    var weightinput = $("#customWeight").val().trim();
    var req = ocpu.call("mainApp",{input:txtinput,
    normalizationMethodsSelection:$scope.normalizationMethodsSelection,
    sampleSpecificMethodsSelection:$scope.sampleSpecificMethodsSelection,
    sampleSpecificWeight:weightinput,
    transformationMethodsSelection:$scope.transformationMethodsSelection,
    logbase:$scope.logbase,
    power:$scope.power,
    scaleMethodsSelection:$scope.scaleMethodsSelection,
    PCA:$scope.PCA,
    Normality:$scope.Normality,
    RSD:$scope.RSD,
    autoSpan:$scope.autoSpan
    }, function(session) {//calls R function:
			console.log(session);
			$scope.$apply(function(){
			  $scope.session = session.loc
			  console.log($scope.session)
			})
			download_address = session.loc + "files/Normalization_Results.zip"
		})
		.done(function(){
        $("#outputpanelheader").removeClass("collapsed")
        $("#output").addClass( "in" );
        $("#outputText").html( "<b style='color:#3C763D;'>Success!</b><br /><div class='well well-sm'><p>You could download the result by clicking the download button.</p><a type='button' href='"+download_address+"' class='btn btn-primary' target='_blank'  download='Normalization_Results.zip'>Download</a>" );
		})
		.fail(function() {
		  $('#outputText').empty();
      $("#outputText").html("<p>No output yet.</p>")
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
