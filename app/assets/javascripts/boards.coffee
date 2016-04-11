# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
notes = []
url_array = window.location.href.split('/');
board_id = url_array[url_array.length-1]
reg = new RegExp('^\\d+$');
if reg.test board_id
  source = new EventSource('/notes/events/'+board_id)
  
  source.addEventListener 'notes.delete', (e) ->
    note = $.parseJSON(e.data).note
    $('#note_'+note.id).remove()
    n = notes.indexOf note
    pos = notes.map((e) ->
      e.id
    ).indexOf(note.id)
    if pos > -1
      notes.splice pos, 1
    $( "#note_counter" ).text notes.length
      
  source.addEventListener 'notes.update', (e) ->
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
  
  source.addEventListener 'notes.create', (e) ->
      note = $.parseJSON(e.data).note
      notes.push(note)
      $( "#note_counter" ).text notes.length
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
    $('#trash').droppable 
      tolerance: "touch"
      accept: '.draggable'
      drop: (event, ui) ->
        raw_id = ui.draggable.attr("id");
        $( "#"+raw_id ).addClass('nodrag');
        id = raw_id.replace("note_","")
        img = 
          'id': id
        $.ajax
          type: 'delete'
          beforeSend: (xhr) ->
            xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
            return
          url: '/notes/' + id 
          data: JSON.stringify(img)
          contentType: 'application/json'
          dataType: 'json'
        return
    $.ajax
      url: '/boards/'+board_id+'/notes.json'
      contentType: 'application/json'
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        notes = data
        $( "#note_counter" ).text notes.length
        for note in data
          do (note)->
            $('#board-div').append "<div class='draggable' id='note_"+note.id+"' style='z-index:"+note.id+";background-color:"+note.color+";position:absolute;top:"+note.y+"px;left:"+note.x+"px;' ><p>"+note.text+"</p></div>"
            $('#note_'+note.id).draggable
              scroll: false
              stop: (event, ui) ->
                $this = $(this)
                if $this.hasClass('nodrag')
                  $this.removeClass('nodrag')
                else
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