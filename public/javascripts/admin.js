var admin = {
  configureTabs: function() {
    //When page loads...
	  $(".tab_content").hide(); //Hide all content
	  $("ul.tabs li:first").addClass("active").show(); //Activate first tab
	  $(".tab_content:first").show(); //Show first tab content

    //On Click Event
	  $("ul.tabs li").click(function() {
		  $("ul.tabs li").removeClass("active"); //Remove any "active" class
		  $(this).addClass("active"); //Add "active" class to selected tab
		  $(".tab_content").hide(); //Hide all tab content

		  var activeTab = $(this).find("a").attr("href"); //Find the href attribute value to identify the active tab + content
		  $(activeTab).fadeIn(); //Fade in the active ID content
		  return false;
	  });
  },

  configureColumns: function() {
    $('.column').equalHeight();
  },

  configureWysiwyg: function() {
    var wysiwygs = $('.wysiwyg');
    $.each(wysiwygs, function(i, el) {
      el = $(el);
      if(CKEDITOR.instances[el.attr('id')]) {
        CKEDITOR.remove(CKEDITOR.instances[el.attr('id')]);
      }
      CKEDITOR.replace(el.attr('id'), { language: $('meta[name=locale]').attr('content'), toolbar: 'Easy', filebrowserBrowseUrl: '/ckeditor/attachment_files', filebrowserUploadUrl: '/ckeditor/attachment_files', filebrowserImageBrowseUrl: '/ckeditor/pictures', filebrowserImageUploadUrl: '/ckeditor/pictures' });
    });
  },

  configureTableSort: function() {
    var indexTable = $('table.data-table tbody');

    indexTable.sortable({
      axis: 'y',
      dropOnEmpty: false,
      handle: '.handle',
      cursor: 'crosshair',
      opacity: 0.4,
      scroll: true,
      update: function(e, ui) {
        admin.loading();
        var tr = $(ui.item.context), position = null;
        indexTable.find('tr').each(function(i, el) {
          if($(el).attr('url') == tr.attr('url')) {
            position = i+1;
          }
        });

        $.ajax({
          type: 'post',
          data: admin.data() + '&' + tr.attr('model') + '[sort]=' + position,
          url: tr.attr('url'),
          complete: function(){admin.loading();}
        });
      }
    });
  },

  configureUpdatable: function() {
    $('.updatable').change(function() {
      var self = $(this),
          parent = self.parents('[url][model]:first'),
          val = null;

      if(self.attr('attribute')
          && parent.attr('url') && parent.attr('model')) {
        admin.loading();

        if(self.attr('type') == 'checkbox') {
          val = self.is(':checked') ? self.val() : false;
        } else {
          val = self.val();
        }

        $.ajax({
          type: 'post',
          data: admin.data() + '&' + parent.attr('model') + '['+ self.attr('attribute') +']=' + val,
          url: parent.attr('url'),
          complete: function(){admin.loading();}
        });
      }
    });
  },

  loading: function() {
    $('.ajax_loader_container').toggle();
  },

  data: function() {
    return $('meta[name=csrf-param]').attr('content') + '=' + $('meta[name=csrf-token]').attr('content') + '&_method=PUT'
  }
};

$(document).ready(function() {
  admin.configureTabs();
  admin.configureColumns();
  admin.configureWysiwyg();
  admin.configureTableSort();
  admin.configureUpdatable();
});

