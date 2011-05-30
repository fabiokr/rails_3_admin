$(function() {
  //Configures CKeditor
  var wysiwygs = $('.wysiwyg');
  $.each(wysiwygs, function(i, el) {
    el = $(el);
    if(CKEDITOR.instances[el.attr('id')]) {
      CKEDITOR.remove(CKEDITOR.instances[el.attr('id')]);
    }
    console.log(el.width());
    CKEDITOR.replace(el.attr('id'), { width: el.width(), height: el.height(), toolbar: 'Easy', filebrowserBrowseUrl: '/ckeditor/attachment_files', filebrowserUploadUrl: '/ckeditor/attachment_files', filebrowserImageBrowseUrl: '/ckeditor/pictures', filebrowserImageUploadUrl: '/ckeditor/pictures' });
  });
});

