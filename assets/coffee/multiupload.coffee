
$(document).ready () ->
  new Multiupload $(el) for el in $('.attachment')


class Multiupload

  constructor: (@element, enable_drag = yes) ->
    @element.addClass 'dnd'
    @element.addClass 'dnd-dragenabled' if enable_drag

    @render()
    @enable_multiupload()

    # Dont send the empty file input along
    @element.closest('form').submit () => @input.remove()


  render: () ->
    @build_dropzone()

    @input = @element.find('input').appendTo @dropzone
    @input.addClass 'dnd-file'

    # Fix for Firefox. Has to be attr() to prevent validation
    @input.attr 'size', '100%'


    $('<span>Click or drag file to add as attachment</span>').prependTo @dropzone
    @files = $('<ul class="dnd-filelist">').appendTo @element


  build_dropzone: () ->
    @dropzone = $('<div class="dnd-dropzone" />').appendTo @element

    @dropzone.on 'dragenter', () => @dropzone.addClass 'active'
    @dropzone.on 'dragleave', () => @dropzone.removeClass 'active'


  enable_multiupload: () ->
    @input.on 'change', (e) =>
      @dropzone.removeClass 'active'
      @add_file $(e.target)


  add_file: (file) ->
    filename = file.val().split(/(\\|\/)/g).pop()

    @input = file.clone()
    @dropzone.append @input
    @enable_multiupload()

    @files.append $("<li>#{filename}</li>").append file, @get_remove_link()


  get_remove_link: (file) ->
    $('<a href="#" class="dnd-remove">Remove</a>').click () ->
      $(this).parent().remove() if confirm 'Do you want to remove this attachment?'
      false
