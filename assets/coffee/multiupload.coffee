$ = @jQuery

$.fn.multiupload = () ->
  new Multiupload $(this)


class Multiupload

  constructor: (@element) ->
    @element.addClass 'dnd'
    @render()

    @enable_multiupload()
    # Firefox gets confused with the 
    @enable_drag() if navigator.userAgent?.toLowerCase().indexOf('webkit') isnt -1

    # Dont send the empty file input along
    @element.closest('form').submit () => @input.remove()


  render: () ->
    @dropzone = $('<div class="dnd-dropzone" />').appendTo @element

    @input = @element.find('input').appendTo @dropzone
    @input.prop('multiple', '').addClass 'dnd-file'

    # Fix for Firefox. Has to be attr() to prevent validation
    @input.attr 'size', '100%'

    $('<span>Click here or drag file to add as attachment</span>').prependTo @dropzone
    @files = $('<ul class="dnd-filelist">').appendTo @element


  enable_drag: () ->
    @element.addClass 'dnd-dragenabled'

    @dropzone.on 'dragenter', () => @dropzone.addClass 'dnd-dragging'
    @dropzone.on 'dragleave', () => @dropzone.removeClass 'dnd-dragging'


  enable_multiupload: () ->
    @input.on 'change', (e) =>
      @dropzone.removeClass 'dnd-dragging'
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
