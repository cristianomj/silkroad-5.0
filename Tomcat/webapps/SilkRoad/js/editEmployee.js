function editEmployeeData(el, lastname, firstname, address, zipcode, telephone, email, password, hourlyRate) {
  //element = "customerTableUpdate";
  var employeeID = el.value;
  var getUrl = "?employeeID="+employeeID+"&firstname="+firstname
      +"&lastname="+lastname+"&address="+address+"&zipcode="+zipcode
      +"&telephone="+telephone+"&email="+email+"&password="+password
      +"&hourlyRate="+hourlyRate+"";
      //console.log(url+getUrl);
      window.location = "UpdateEmployeeData.jsp" + getUrl;
}

function deleteEmployee(el) {
  var employeeID = el.value;
  window.location = "DeleteEmployee.jsp?employeeID="+employeeID;
}


function employeeDataAction(el, lastname, firstname, address, zipcode, telephone, email, password, hourlyRate) {
    var action = el.options[el.selectedIndex].text;

    var employeeID = el.options[el.selectedIndex].value;

    if (action == "Edit") {
      //window.location = "http://www.google.com";
      document.getElementById("employeeID").value = employeeID;
      document.getElementById("lastname").value = lastname;
      document.getElementById("firstname").value = firstname;
      document.getElementById("address").value = address;
      document.getElementById("zipcode").value = zipcode;
      document.getElementById("telephone").value = telephone;
      document.getElementById("email").value = email;
      document.getElementById("password").value = password;
      document.getElementById("hourlyRate").value = hourlyRate;
     // document.getElementById("state").value = state;
      $("#editEmployeeModal").modal('show');
    } else if (action == "Delete") {
     document.getElementById("toBeDeleted").value = firstname + lastname + "?";
         $("#deleteEmployeeModal").modal('show');
    }
}

// function SuggestCustomerItemList(el, username) {
//  var customerID = el.value;
//
//  window.location = "CustomerSuggestions.jsp?customerID="+customerID+"&username="+username;
//
//
// }
