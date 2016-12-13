(function($) {
  var V = window.V = window.V ? (window.V) : {};

  /* UPLOADER
  -------------------------------------------------- */
  V.uploader = (function() {

    /* Private members */

    var settings = {
      maxSizeInMB: 10,
      mimeTypes: /pdf|save|msword|wordprocessingml|jpeg|png/i,
      urlToPost: "upload" 
    };

    bindButtonEvents = function(c, min, max) {

      /* Plus button */
      $("#plus_" + c).on("click", function(e) {      
        e.preventDefault();
        var lastIndex = getLastIndex(c);    
        setButtonsEnablement(c, lastIndex + 1, min, max);
        $(getDOMFile(c, lastIndex + 1)).insertAfter( "#" + c + "_hidden_" + lastIndex );
        $(getDOMHidden(c, lastIndex + 1)).insertAfter( "#" + c + "_file_" + (lastIndex + 1) );
      });

      /* Minus button */
      $("#minus_" + c).on("click", function(e) {
        e.preventDefault();
        var lastIndex = getLastIndex(c);
        $("#" + c + "_file_" + lastIndex + ", #" + c + "_hidden_" + lastIndex).remove();
        setButtonsEnablement(c, lastIndex - 1, min, max);
      });
    };

    bindFileChangeEvent = function(e) {

      var file = e.files[0];
      var label = $("label[for=\"" + $(e).attr("id") +  "\"]");

      // removing validations
      $(label).removeClass("red");
      $(label).removeAttr("title"); 

      var validation = validateFile(file); 
      if (validation.status == "ERROR") {
        $(label).addClass("red");
        $(label).attr("title","Erro ao carregar o anexo. Por favor, verifique as extensões e tamanho permitidos");
        return;
      }

      uploadFile(e.id, file);
    };

    configUploadURL = function(reader, file, ctrl) {
 
      var buffer = reader.target.result;
      var bufferView = new Uint8Array(buffer);
    
      var queryParams = [["filename", file.name], ["mimetype", file.type], ["size", file.size]]
      queryParams.push(["hash", generateRandonName(30)]);
      queryParams.push(["control", ctrl]); 
    
      var queryString = queryParams.map(function(p) { return p[0] + "=" + encodeURIComponent(p[1]) }).join("&");
      var uploadURL = settings.urlToPost + "?" + queryString
   
      var hidden = ctrl.replace("file", "hidden");

      sendFileToServer(uploadURL, bufferView, hidden); 
    };

    generateRandonName = function(n) {
      var str = '', possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      for ( var i = 0; i < n; i++ ) {
        str += possible.charAt(Math.floor(Math.random() * possible.length));
      }
      return str;
    }

    getDOMFile = function(c, i) {
      return "<input id=\"" + c + "_file_" + i + "\" name=\"" + c + "_file_" + i + "\" class=\"" +c  + "_file\"  type=\"file\" onchange=\"bindFileChangeEvent(this);\" />";
    };
  
    getDOMHidden = function(c, i) {
      return "<input id=\"" + c + "_hidden_" + i + "\" name=\"" + c + "_hidden_" + i + "\" type=\"hidden\" />";
    };

    getLastIndex = function(c) {
      var length = $("." + c + "_file").length;
      return length;
    };
    
    sendFileToServer = function sendXHR(uploadURL, bufferView, ctrl) {

      $("<div id=\"loader_" + ctrl + "\"><img src=\"assets/images/ajax-loader.gif\" /></div>").insertAfter($("#" + ctrl));

      var xhr = new XMLHttpRequest();
      xhr.open("POST", uploadURL);
      xhr.setRequestHeader("Content-Type", "text/plain"); // Safari fix - it always sends application/x-www-form-urlencoded
      xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
      xhr.setRequestHeader("Cache-Control", "no-store, no-cache, must-revalidate, post-check=0, pre-check=0");
      xhr.setRequestHeader("Pragma", "no-cache");
      xhr.onreadystatechange = function(e) {

        if (xhr.readyState === 4) {

          $("#loader_" + ctrl).remove();

          if (xhr.status === 200) {
            var res = JSON.parse(xhr.response);
            $("#" + ctrl).val(res.file);

            // finding file control from the match hidden control
            var ctrlFile = ctrl.replace("hidden","file");
            var label = $("label[for=\"" + ctrlFile +  "\"]");
            $(label).addClass("green");
            $(label).attr("title","Anexo carregado com sucesso");

            // paints the row
            if (ctrl.indexOf("syllabus") >= 1 || ctrl.indexOf("program") >= 1) {
              blurTr($("#" + ctrl).closest("tr"));
            }
          }
        }
      }
      xhr.send(bufferView);
    };

    setButtonsEnablement = function(c, lastIndex,  min, max) {
      $("#plus_" + c).attr("disabled", lastIndex >= max); 
      $("#minus_" + c).attr("disabled", lastIndex <= min);
    };

    uploadFile = function(ctrl, file) {
      var reader = new FileReader();
      reader.onload = function(e) {
        configUploadURL(e, file, ctrl);
      }
      reader.readAsArrayBuffer(file);
    };

    validateFile = function(file) {

      if (!file.type.match(settings.mimeTypes)) {
        return { status: "ERROR", message: "A extensão deste arquivo não é permitida. Substitua-o por outro com extensão .PDF, .DOC, .DOCX, .JPG, .PNG ou .ZIP" }
      }
      //if ((file.size / 1024 / 1024) > settings.maxSizeInMB) {
      if ((file.size / 1000000) > settings.maxSizeInMB) {
        return { status: "ERROR", message: "O tamanho deste arquivo não é permitido. Substitua-o por outro com no máximo 10MB." }
      }
      return { status: "OK" };
    };

    
    /* Public members */

    draw = function(ctrl, c, q, min, max) {
      if (min < 1) { throw new Error("Deve haver ao menos um campo de upload!"); }
    
      var dom = "";
      for (var i = 1; i <= q; i++) {
        dom += getDOMFile(c, i);
        dom += getDOMHidden(c, i);
      }
      if (min != max) {
        dom += "<button id=\"plus_" + c + "\" class=\"btn btn-sm btn-mais\"><span class=\"glyphicon glyphicon-plus\"></span> Adicionar</button>";
        dom += "<button id=\"minus_" + c + "\" class=\"btn btn-sm btn-menos\"><span class=\"glyphicon glyphicon-minus\"></span> Remover</button>";
      }
      //dom += "<i class=\"fa fa-info-circle m-l-xl\" style=\"cursor:pointer;margin-left:5px;\" title=\"São permitidos apenas arquivos com as extensões .PDF, .DOC, .DOCX, .JPG, .PNG ou .ZIP e com tamanho máximo de 10 MB\"></i>";

      $(dom).insertAfter(ctrl);

      bindButtonEvents(c, min, max);
      setButtonsEnablement(c, q, min, max);
    };

    return {      
      draw: draw
    }

  }());


  /* VALIDATOR
  -------------------------------------------------- */
  V.validator = (function() {

    /* Private members */
    var settings = {
      requiredClass: "required"
      // phoneClass: "phone" TODO
    } 
     
    areAttachsValid = function(c) {
      var res = true;
  
      // Only for attach containers
      if (!$("#" + c.id).hasClass("attach-field")) { return res; }
    
      $("#" + c.id + " input[type=hidden]").each(function(i, el) {
        if (el.value.trim().length == 0) { res = false; return; }
      });      

      return res;
    };

    /* Public methods */

    setAsterisks = function() { // TODO      
      //var label = $("." + settings.requiredClass);
      //$("<span> *</span>").css("color", "red").appendTo(label); 
    }

    validate = function() {
      var res = { status: "ok" };

      // Default
      $(".validation-area").removeClass("invalid-area");
      $(".validation-notice").remove();

      // Required
      $("." + settings.requiredClass).each( function(i, el) {
        
        var parentDiv = $(this).closest(".validation-area");
        var tag = el.tagName.toLowerCase();

        if ( el.style.display != "none" &&
          ( ( (tag == "input" || tag == "textarea") && el.value.trim().length == 0 ) 
          || (tag == "select" && (el.selectedOptions[0].index < 1 || el.selectedOptions[0].disabled) )
          || ( (tag == "div" && el.className.indexOf("attach-field") != -1) && !areAttachsValid(el) )
          )
          ) {

          $(parentDiv).addClass("invalid-area");
          if (!$(parentDiv).find(".validation-notice").length) {
            $(parentDiv).append("<span class=\"help-block validation-notice\" style=\"color: red\">O campo precisa ser preenchido</span>");
          }
          else {
            $(parentDiv).find(".validation-notice").html("Todos os campos precisam ser preenchidos");
          }
           
          res = { status: "error" };
        }       
                
      });

      return res;
    };

    return {
      //setAsterisks: setAsterisks, TODO
      validate: validate
    }

  }());

}(jQuery));
