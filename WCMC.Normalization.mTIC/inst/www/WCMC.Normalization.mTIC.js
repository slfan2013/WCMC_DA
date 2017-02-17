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
			view_address = session.loc + "files/mTIC-normalization.txt"
			download_address = session.loc + "files/mTIC-normalization.csv"
		})
		.done(function(){
$("#outputpanelheader").removeClass("collapsed")
$("#output").addClass( "in" );
$("#output").html( "<b style='color:#3C763D;'>Success!</b><br /><div class='well well-sm'><p>Data were normalized sample by sample to the average of the sum intensity of all annotated metabolites (using the following Eq.)</p><div class='f'>metabolite<sub>ij,normalized</sub> =&nbsp; metabolite<sub>ij, raw</sub>/mTIC<sub>j</sub>* mTIC average<span>, where <em>i</em> indicates sample while <em>j</em> indicates compound.</span></div> </div><p style='color:grey';'>You can either view your normalized result <a href='"+view_address+"' target='_blank'>here</a>, or download your result by clicking the Download button.</p><a type='button' href='"+download_address+"' class='btn btn-primary' target='_blank'  download='mTIC-normalization.csv'>Download</a>" );
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
