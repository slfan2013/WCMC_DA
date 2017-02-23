function showSpinner(txt=null){
    $('#spinner').modal('show');
    var opts = {
      lines: 10, // The number of lines to draw
      length: 8, // The length of each line
      width: 10, // The line thickness
      radius: 20, // The radius of the inner circle
      corners: 1, // Corner roundness (0..1)
      rotate: 0, // The rotation offset
      direction: 1, // 1: clockwise, -1: counterclockwise
      color: '#0073b7', // #rgb or #rrggbb or array of colors
      speed: 1, // Rounds per second
      trail: 60, // Afterglow percentage
      shadow: false, // Whether to render a shadow
      hwaccel: false, // Whether to use hardware acceleration
      className: 'spinner', // The CSS class to assign to the spinner
      zIndex: 2e9, // The z-index (defaults to 2000000000)
      top: 'auto', // Top position relative to parent in px
      left:'auto' // Left position relative to parent in px
    };
    var spinner = new Spinner(opts).spin(document.getElementById('loading_spinner'));//assign spinner to modal box
    $("#notifyTxt").text(txt);
    return spinner;
}

//@function hide spinner
function hideSpinner(spinner){
    spinner.stop();
    $('#spinner').modal('hide');
}