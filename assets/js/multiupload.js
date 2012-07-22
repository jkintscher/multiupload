(function() {
  var Multiupload;

  $(document).ready(function() {
    var el, _i, _len, _ref, _results;
    _ref = $('.attachment');
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      el = _ref[_i];
      _results.push(new Multiupload($(el)));
    }
    return _results;
  });

  Multiupload = (function() {

    function Multiupload(element, enable_drag) {
      var _this = this;
      this.element = element;
      if (enable_drag == null) enable_drag = true;
      this.element.addClass('dnd');
      if (enable_drag) this.element.addClass('dnd-dragenabled');
      this.render();
      this.enable_multiupload();
      this.element.closest('form').submit(function() {
        return _this.input.remove();
      });
    }

    Multiupload.prototype.render = function() {
      this.build_dropzone();
      this.input = this.element.find('input').appendTo(this.dropzone);
      this.input.addClass('dnd-file');
      this.input.attr('size', '100%');
      $('<span>Click or drag file to add as attachment</span>').prependTo(this.dropzone);
      return this.files = $('<ul class="dnd-filelist">').appendTo(this.element);
    };

    Multiupload.prototype.build_dropzone = function() {
      var _this = this;
      this.dropzone = $('<div class="dnd-dropzone" />').appendTo(this.element);
      this.dropzone.on('dragenter', function() {
        return _this.dropzone.addClass('active');
      });
      return this.dropzone.on('dragleave', function() {
        return _this.dropzone.removeClass('active');
      });
    };

    Multiupload.prototype.enable_multiupload = function() {
      var _this = this;
      return this.input.on('change', function(e) {
        _this.dropzone.removeClass('active');
        return _this.add_file($(e.target));
      });
    };

    Multiupload.prototype.add_file = function(file) {
      var filename;
      filename = file.val().split(/(\\|\/)/g).pop();
      this.input = file.clone();
      this.dropzone.append(this.input);
      this.enable_multiupload();
      return this.files.append($("<li>" + filename + "</li>").append(file, this.get_remove_link()));
    };

    Multiupload.prototype.get_remove_link = function(file) {
      return $('<a href="#" class="dnd-remove">Remove</a>').click(function() {
        if (confirm('Do you want to remove this attachment?')) {
          $(this).parent().remove();
        }
        return false;
      });
    };

    return Multiupload;

  })();

}).call(this);
