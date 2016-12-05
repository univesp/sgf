/* Evento que dispara quando o jQuery carrega */
$(document).ready(function() {

  $("#course").on("change", function() {
    courseId = $(this).val();


    /*$.ajax({
      url: 'vagas-remanescentes/univesp-activities',
      data: { paramCourseId: courseId }      
    })
    .done(function(data) {
      alert(data);
    })
    .fail(function() {
      alert( "error" );
    });*/

    $.ajax({
      type: "GET",
      url: "vagas-remanescentes/univesp-activities",
      data: { courseId: courseId },
      dataType: "json",
      error: function(xhr, status, error) {
        alert(error);
        // you may need to handle me if the json is invalid
        // this is the ajax object
      },
      success: function(json){
        var html = "";


      for(var i=1; i<json.length;i++) {
                     
        html += `<tr class='success'>
          <td>
          <div class='checkbox m-t-xs m-b-xs'>
          <label for='lala'>
          <input class='limpa1' type='checkbox' value='<%= activity[:value] %>'> `;
        html += json[i].text;
        html += ` </input>
          </label>
          </div>
          </td>
          <td>
          <input class='form-control limpa2' type='text'></input>
          </td>
          <td>
          <input class='form-control limpa3' type='number'></input>
          </td>
          <td>
          <div class='image-upload'>
          <label class='btn btn-default' for='ementa'>
          <span class='fa fa-paperclip'></span>
          ementa
          </label>
          <input class='ementa fileInput' type='file'></input>
          </div>
          </td>
          <td>
          <div class='image-upload'>
          <label class='btn btn-default' for='program'>
          <span class='fa fa-paperclip'></span>
          programa
          </label>
          <input class='program file' type='file'></input>
          </div>
          </td>
          <td>
          <input id='clear' onclick='resetForm();' type='button' value='X'></input>
          </td>
          </tr>`;  
       
      }

      
    $.ajax({
      type: "GET",
      url: "vagas-remanescentes/univesp-classes",
      data: { courseId: courseId },
      dataType: "json",
      error: function(xhr, status, error) {
        alert(error);
        // you may need to handle me if the json is invalid
        // this is the ajax object
      },
      success: function(json){
        var html = "";


      for(var i=1; i<json.length;i++) {

        html += `<select class='form-control' name='classe[]' style='width:90%;'>
          <option value='<%= classe[:value] %>'>`;
        html += json[i].text;
        html += ` </option>
          </select>`;
      }







});





$(function () {
          function removeCampo() {
          $(".removerCampo").unbind("click");
          $(".removerCampo").bind("click", function () {
             if($("tr.linhas").length > 1){
            $(this).parent().parent().remove();
             }
          });
          }
         
          $(".adicionarCampo").click(function () {
          novoCampo = $("tr.linhas:first").clone();
          novoCampo.find("input").val("");
          novoCampo.insertAfter("tr.linhas:last");
          removeCampo();
          });
        });

      $(function() {
        var form = new FormMain();
        form.init();
        form.handlePageEvents();      
      });


      function mascara(o,f){
        v_obj=o
        v_fun=f
        setTimeout("execmascara()",1)
      }
          function execmascara(){
              v_obj.value=v_fun(v_obj.value)
          }

          function id( el ){
                  return document.getElementById( el );
          }
          function next( el, next )
          {
                  if( el.value.length >= el.maxLength )
                          id( next ).focus();
          }
          function cpf_mask(v){
              v=v.replace(/\D/g,"")                 //Remove tudo o que não é dígito
              v=v.replace(/(\d{3})(\d)/,"$1.$2")    //Coloca ponto entre o terceiro e o quarto dígitos
              v=v.replace(/(\d{3})(\d)/,"$1.$2")    //Coloca ponto entre o setimo e o oitava dígitos
              v=v.replace(/(\d{3})(\d)/,"$1-$2")   //Coloca ponto entre o decimoprimeiro e o decimosegundo dígitos
              return v
          }


          function mphone(v){
              v=v.replace(/\D/g,"");             //Remove tudo o que não é dígito
              v=v.replace(/^(\d{2})(\d)/g,"($1) $2"); //Coloca parênteses em volta dos dois primeiros dígitos
              v=v.replace(/(\d)(\d{4})$/,"$1-$2");    //Coloca hífen entre o quarto e o quinto dígitos
              return v;
          }
          function id( el ){
              return document.getElementById( el );
          }
          window.onload = function(){
              id('phone').onkeyup = function(){
                  mascara( this, mphone );
              }
          }

          function validarCPF( cpf ){
              var filtro = /^\d{3}.\d{3}.\d{3}-\d{2}$/i;
              
              if(!filtro.test(cpf))
              {
                  window.alert("CPF inválido. Tente novamente.");
                  return false;
              }
             
              cpf = remove(cpf, ".");
              cpf = remove(cpf, "-");
              
              if(cpf.length != 11 || cpf == "00000000000" || cpf == "11111111111" ||
                  cpf == "22222222222" || cpf == "33333333333" || cpf == "44444444444" ||
                  cpf == "55555555555" || cpf == "66666666666" || cpf == "77777777777" ||
                  cpf == "88888888888" || cpf == "99999999999")
              {
                  window.alert("CPF inválido. Tente novamente.");
                  return false;
             }

              soma = 0;
              for(i = 0; i < 9; i++)
              {
                  soma += parseInt(cpf.charAt(i)) * (10 - i);
              }
              
              resto = 11 - (soma % 11);
              if(resto == 10 || resto == 11)
              {
                  resto = 0;
              }
              if(resto != parseInt(cpf.charAt(9))){
                  window.alert("CPF inválido. Tente novamente.");
                  return false;
              }
              
              soma = 0;
              for(i = 0; i < 10; i ++)
              {
                  soma += parseInt(cpf.charAt(i)) * (11 - i);
              }
              resto = 11 - (soma % 11);
              if(resto == 10 || resto == 11)
              {
                  resto = 0;
              }
              
              if(resto != parseInt(cpf.charAt(10))){
                  window.alert("CPF inválido. Tente novamente.");
                  return false;
              }
              
              return true;
           }
           
          function remove(str, sub) {
              i = str.indexOf(sub);
              r = "";
              if (i == -1) return str;
              {
                  r += str.substring(0,i) + remove(str.substring(i + sub.length), sub);
              }
              
              return r;
          }

 function resetForm(){
  with (document) {
    getElementByClass("limpa1").checked = false;
    getElementByClass("limpa2").value = "";
    getElementByClass("limpa3").value = "";
  }
}
