// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.

function pressButton(dataDriveGo, dataDriveTurn){
  if(dataDriveGo || dataDriveGo == 0)
    $(".drive_control[data-drive-go]").removeClass("pressed");
  if(dataDriveTurn || dataDriveTurn == 0)
    $(".drive_control[data-drive-turn]").removeClass("pressed");
  $(".drive_control[data-drive-go= " + dataDriveGo + "]").addClass("pressed");
  $(".drive_control[data-drive-turn= " + dataDriveTurn + "]").addClass("pressed");
}

var isGoing   = false;
var isTurning = false;

function keyboardControl(e) {

    // GO!
  if(e.which == 87 && !isGoing) {
    // console.log("GO!");
    isGoing = true;
    $.get("/go?dir=1", function(data) {
      console.log(data);
      pressButton(1, undefined);
      $(document).on("keyup", function(e) {
        if(e.which == 87 && isGoing) {
          isGoing = false;
          $.get("/go?dir=0", function(data) {
            console.log(data);
            pressButton(0, undefined);
          });
        }
      });
    });
  }
  // GO BACK!
  if(e.which == 83 && !isGoing) {
    // console.log("GO BACK!");
    isGoing = true;
    $.get("/go?dir=-1", function(data){
      console.log(data);
      pressButton(-1, undefined);
      $(document).on("keyup", function(e) {
        if(e.which == 83 && isGoing) {
          isGoing = false;
          $.get("/go?dir=0", function(data) {
            console.log(data);
            pressButton(0, undefined);
          });
        }
      });
    });
  }
  // TURN LEFT
  if(e.which == 65 && !isTurning) {
    isTurning = true;
    $.get("/turn?dir=-1", function(data){
      console.log(data);
      pressButton(undefined, -1);
      $(document).on("keyup", function(e) {
        if(e.which == 65 && isTurning) {
          isTurning = false;
          $.get("/turn?dir=0", function(data) {
            console.log(data);
            pressButton(undefined, 0);
          });
        }
      });
    });
  }
  // TURN RIGHT
  if(e.which == 68 && !isTurning) {
    isTurning = true;
    $.get("/turn?dir=1", function(data){
      console.log(data);
      pressButton(undefined, 1);
      $(document).on("keyup", function(e) {
        if(e.which == 68 && isTurning) {
          isTurning = false;
          $.get("/turn?dir=0", function(data) {
            console.log(data);
            pressButton(undefined, 0);
          });
        }
      });
    });
  }
}

/* Copyright (C) 2007 Richard Atterer, richardÂ©atterer.net
   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License, version 2. See the file
   COPYING for details. */

var imageNr = 0; // Serial number of current image
var finished = new Array(); // References to img objects which have finished downloading
var paused = false;
var webcam_server_uri = "";

function createImageLayer(my_webcam_server_uri) {
  var img = new Image();

  if(my_webcam_server_uri)
    webcam_server_uri = my_webcam_server_uri;
  img.style.position = "absolute";
  img.style.zIndex = -1;
  img.onload  = imageOnload;
  img.onclick = imageOnclick;
  img.src = webcam_server_uri + "/?action=snapshot&n=" + (++imageNr);
  var webcam = document.getElementById("video_stream");
  webcam.insertBefore(img, webcam.firstChild);
}

// Two layers are always present (except at the very beginning), to avoid flicker
function imageOnload() {
  if(imageNr > 1000)
    imageNr = 0;
  this.style.zIndex = imageNr; // Image finished, bring to front!
  while (1 < finished.length) {
    var del = finished.shift(); // Delete old image(s) from document
    del.parentNode.removeChild(del);
  }
  finished.push(this);
  if (!paused) createImageLayer(webcam_server_uri);
}

function imageOnclick() { // Clicking on the image will pause the stream
  paused = !paused;
  if (!paused) createImageLayer();
}

