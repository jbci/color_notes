# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
source = new EventSource('/notes/events')
source.addEventListener 'message', (e) ->
    console.log e
    note = $.parseJSON(e.data).note
    $('#note_'+note.id).remove()
    $('#board-div').append "<div class='draggable' id='note_"+note.id+"' style='z-index:"+note.id+";background-color:"+note.color+";position:absolute;top:"+note.y+"px;left:"+note.x+"px;' ><p>"+note.text+"</p></div>"
    $('#note_'+note.id).draggable
      scroll: false
      stop: (event, ui) ->
        $this = $(this)
        thisPos = $this.position()
        parentPos = $this.parent().position()
        id = $(this).attr('id').replace("note_","")
        img = 
          'id': id
          'x': thisPos.left
          'y': thisPos.top
        $.ajax
          type: 'put'
          beforeSend: (xhr) ->
            xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
            return
          url: '/notes/' + id + '.json'
          data: JSON.stringify(img)
          contentType: 'application/json'
          dataType: 'json'
        return
   
    
    
$(document).on "page:change", ->
  $.ajax
    url: '/boards/1.json'
    # url: '/notes/' + $(this).attr('id') + '.json'
    contentType: 'application/json'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      alert "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      for note in data.notes
        do (note)->
          $('#board-div').append "<div class='draggable' id='note_"+note.id+"' style='z-index:"+note.id+";background-color:"+note.color+";position:absolute;top:"+note.y+"px;left:"+note.x+"px;' ><p>"+note.text+"</p></div>"
          $('#note_'+note.id).draggable
            scroll: false
            stop: (event, ui) ->
              $this = $(this)
              thisPos = $this.position()
              parentPos = $this.parent().position()
              id = $(this).attr('id').replace("note_","")
              img = 
                'id': id
                'x': thisPos.left
                'y': thisPos.top
              $.ajax
                type: 'put'
                beforeSend: (xhr) ->
                  xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
                  return
                url: '/notes/' + id + '.json'
                data: JSON.stringify(img)
                contentType: 'application/json'
                dataType: 'json'
              return
    


# ---
# generated by js2coffee 2.2.0