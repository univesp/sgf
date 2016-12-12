function blurTr(tr) {
  $(tr).removeClass("active");
  $(tr).removeClass("success");
  if (isTrFullyCompleted(tr)) {
    $(tr).addClass("success");    
  } else if (isTrPartlyCompleted(tr)) {
    $(tr).addClass("active");
  } 
}

function clearRow(e) {
   var tr = $(e).closest("tr");
    $(tr).removeClass("active");
    $(tr).removeClass("success");

    $(tr).find(".check-activities").prop("checked", false);
    $(tr).find(".external-activities").val("");
    $(tr).find(".external-workload").val("");
    $(tr).find("input[type='hidden'][name*='syllabus']").val("");
    $(tr).find("input[type='hidden'][name*='program']").val("");
    $(tr).find("label").removeClass("green");
    $(tr).find("label").removeClass("red");
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
    payment: $("#payment_file_1").val(),
    externalInstitution: $("#external-institution").val().trim(),
    externalCourse: $("#external-course").val().trim(),
    currentStatus: $('input[name=current-status]:checked').val(),
    diploma: $("#diploma_file_1").val(),
    enrollment: $("#enrollment_file_1").val(),
    academicRecord: $("#academic-record_file_1").val(),
    firstLocation: $("#first-class-area select option:selected").val(),
    secondLocation: $("#second-class-area select option:selected").val(),
    thirdLocation: $("#third-class-area select option:selected").val(),
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
        syllabus: $(ctrl).find("input[type='hidden'][name*='syllabus']").val(),
        program: $(ctrl).find("input[type='hidden'][name*='program']").val()
      }       
      arrayToFill.push(row);         
    }
  });
}

function handleOtherSelects(e) {
  var optionValue = $(e).val();
  var containerId = $($(e).parents(".classes-selects")[0]).attr("id");

  if (containerId == "first-class-select") {
    $("#second-class-area select").val("");
    $("#second-class-area select option").css("display","block");

    $("#third-class-area select").val("");
    $("#third-class-area select option").css("display","block");
    $("#third-class-area").css("display","none");

    if (optionValue == "") {
      $("#second-class-area").css("display","none");
    } else {
      $("#second-class-area").css("display","block");
      var optionToHide = $("#second-class-area select option[value=" + optionValue + "]")
      $(optionToHide).css("display","none");
    }

  } else if (containerId == "second-class-select") {
    $("#third-class-area select").val("");
    $("#third-class-area select option").css("display","block");

    if (optionValue == "") {
      $("#third-class-area").css("display","none");
    } else {
      $("#third-class-area").css("display","block");
      var optionToHide = $("#third-class-area select option[value=" + optionValue + "]")
      $(optionToHide).css("display","none");
      // selected option of the first class must also be considered
      var firstClassOptionValue = $("#first-class-area select").val();
      optionToHide = $("#third-class-area select option[value=" + firstClassOptionValue + "]")
      $(optionToHide).css("display","none");
    }
  }
}

function isTrFullyCompleted(tr) {
  return $(tr).find(".external-activities").val().trim().length >= 1
    && $(tr).find(".external-workload").val().trim().length >= 1
    && $(tr).find("input[type='hidden'][name*='syllabus']").val().trim().length >= 1
    && $(tr).find("input[type='hidden'][name*='program']").val().trim().length >= 1
}

function isTrPartlyCompleted(tr) {
  return $(tr).find(".external-activities").val().trim().length >= 1
    || $(tr).find(".external-workload").val().trim().length >= 1
    || $(tr).find("input[type='hidden'][name*='syllabus']").val().trim().length >= 1
    || $(tr).find("input[type='hidden'][name*='program']").val().trim().length >= 1
}
