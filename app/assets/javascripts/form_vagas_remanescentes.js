function blurTr(tr) {
  $(tr).removeClass("active");
  $(tr).removeClass("success");
  if (isTrFullyCompleted(tr)) {
    $(tr).addClass("success");    
  } else if (isTrPartlyCompleted(tr)) {
    $(tr).addClass("active");
  } 
}

function collectValuesFromForm() {
  var formData = {
    name: $("#name").val().trim(),
    email: $("#email").val().trim(),
    phone: $("#phone").val().trim(),
    mobile: $("#mobile").val().trim(),
    cpf: $("#cpf").val().trim(),
    birthDay: $("#birth-day option:selected").val(),
    birthMonth: $("#birth-month option:selected").val(),
    birthYear: $("#birth-year option:selected").val(),
    course: $("#course option:selected").val(),
    payment: $("#payment")[0].files,
    externalInstitution: $("#external-institution").val().trim(),
    externalCourse: $("#external-course").val().trim(),
    currentStatus: $('input[name=current-status]:checked').val(),
    diploma: $("#diploma")[0].files,
    enrollment: $("#enrollment")[0].files,
    academicRecord: $("#academic-record")[0].files,
    firstLocation: $("#first-location option:selected").val(),
    secondLocation: $("#second-location option:selected").val(),
    thirdLocation: $("#third-location option:selected").val(),
    locationConfirm: $("#location-confirm").is(":checked")
  };

  // Tables
  if ($("#basic-activities-table table").length) {
    formData.basicActivities = [];
    collectValuesFromActivitiesRow("basic-activities-table", formData.basicActivities);
  }
  if ($("#professional-activities-table table").length) {
    formData.professionalActivities = [];
    collectValuesFromActivitiesRow("professional-activities-table", formData.professionalActivities);
  }

  return formData;
}

function collectValuesFromActivitiesRow(tableId, arrayToFill) {
  $("#" + tableId + " tr").each(function(index, ctrl) {
    // row with data
    if (($(ctrl).find(".activities-ids").length)
      && isTrPartlyCompleted(ctrl)) {
      var row = {
        activityId: $(ctrl).find(".activities-ids").val(),
        externalActivities: $(ctrl).find(".external-activities").val().trim(),
        externalWorkload: $(ctrl).find(".external-workload").val().trim(),
        syllabus: $(ctrl).find(".attachs-activities")[0].files,
        program: $(ctrl).find(".attachs-activities")[1].files
      }       
      arrayToFill.push(row);         
    }
  });
}

function isTrFullyCompleted(tr) {
  return $(tr).find(".external-activities").val().trim().length >= 1
    && $(tr).find(".external-workload").val().trim().length >= 1
    && $(tr).find(".attachs-activities")[0].files.length >= 1
    && $(tr).find(".attachs-activities")[1].files.length >= 1
}

function isTrPartlyCompleted(tr) {
  return $(tr).find(".external-activities").val().trim().length >= 1
    || $(tr).find(".external-workload").val().trim().length >= 1
    || $(tr).find(".attachs-activities")[0].files.length >= 1
    || $(tr).find(".attachs-activities")[1].files.length >= 1
} 

function uploadFileActivity(e) {
  if ($(e)[0].files.length >= 1) {
    var td = $(e).closest("td");
    $(td).find(".fa").removeClass("fa-paperclip");
    $(td).find(".fa").addClass("fa-check");
    $(td).find(".label-upload").html("OK");
    $(td).find("label").addClass("green");
    blurTr($(e).closest("tr"));
  }
}
