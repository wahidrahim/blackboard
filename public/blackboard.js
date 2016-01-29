var canvas = new fabric.Canvas('canvas', {
  //backgroundImage: 'chalkboard.png',
  backgroundColor: '#222',
  width: 1152,
  height: 720,
  isDrawingMode: true,
});

//canvas.freeDrawingBrush.color = $('#color').val();
//canvas.freeDrawingBrush.width = 5;

$('#color').change(function(e) {
  canvas.freeDrawingBrush.color = $('#color').val();
  //canvas.freeDrawingBrush.color = 'rgba(255, 255, 255, 0.5)';
});

$('#width').on('input', function(e) {
  var val = $('#width').val();

  canvas.freeDrawingBrush.width = val;
  $('#widthField').val(val);
})

$('#color').change();
$('#width').trigger('input');
