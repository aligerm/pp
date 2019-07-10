jQuery(document).ready(function() {
  var audio = new Audio()
  var admin;
  admin = $('#admin');
  if ($('#admin').length > 0) {
    return App.admin = App.cable.subscriptions.create({
      channel: "AdminChannel",
      admin_id: admin.data('admin-id')
    }, {
      connected: function() {},
      disconnected: function() {},
      received: function(data) {
        var modal, time;
        if (data['type'] === 'objection') {
          $("#myModal").remove();
          modal = '<div class="modal objection-modal d-flex align-items-center justify-content-center" id="myModal"><div class=""><div class="modal-content"><div class="modal-body text-center" ><div id="objection-text">' + data['text'] + '</div> <div class="countdown animated flipInX d-flex align-items-center justify-content-center"><div class="progress"><div id="dynamic" class="progress-bar progress-bar-success progress-bar-striped active" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 100%"><span id="current-progress"></span></div></div><span class="timer" id="timeralli"></span></div></div></div></div></div>';
          $("body").append(modal);
          $("#play-contant").addClass("blur");
          $("#myModal").show();
          time = startTimerModal('10', document.getElementById('timeralli'));
          if(!audio.paused)
            audio.pause()
            if(data['url'] != undefined){
              audio = new Audio(data['url']);
              audio.play()
            }
        }
      }
    });
  }
});
