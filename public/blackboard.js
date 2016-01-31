var canvas = new fabric.Canvas('canvas', {
  backgroundColor: '#222',
  width: 1152,
  height: 720,
  isDrawingMode: true,
});



$('#color').change(function(e) {
  canvas.freeDrawingBrush.color = $('#color').val();
  $('#brush-style').css({
    'background': canvas.freeDrawingBrush.color
  });
});

$('#width').on('input', function(e) {
  var val = $('#width').val();

  canvas.freeDrawingBrush.width = val;
  $('#widthField').val(val);
  $('#brush-style').css({
    'height': canvas.freeDrawingBrush.width,
    'width': canvas.freeDrawingBrush.width
  });
})

$('#brush-style').css({'border-radius': '100%'});

$('#color').change();
$('#width').trigger('input');
