function editCustomerData(el, lastname, firstname, address, zipcode, telephone, email, password, creditCardNum) {
  //element = "customerTableUpdate";
  var customerID = el.value;
  var url = "UpdateCustomerData.jsp";
  var getUrl = "?customerID="+customerID+"&firstname="+firstname
      +"&lastname="+lastname+"&address="+address+"&zipcode="+zipcode
      +"&telephone="+telephone+"&email="+email+"&password="+password
      +"&creditCardNum="+creditCardNum+"";
      console.log(url+getUrl);
      window.location = "UpdateCustomerData.jsp" + getUrl;
}

function getCustomerID(e1) {
    var output = document.getElementById("testing123");
    output.innerHTML = el.value;
    //window.location = "https://www.google.com/?gws_rd=ssl#q=made+it";
}


function customerDataAction(el, lastname, firstname, address, zipcode, telephone, email, password, creditCardNum) {
    var action = el.options[el.selectedIndex].text;

    var customerID = el.options[el.selectedIndex].value;

    if (action == "Edit") {
      //window.location = "http://www.google.com";
      document.getElementById("customerID").value = customerID;
      document.getElementById("lastname").value = lastname;
      document.getElementById("firstname").value = firstname;
      document.getElementById("address").value = address;
      document.getElementById("zipcode").value = zipcode;
      document.getElementById("telephone").value = telephone;
      document.getElementById("email").value = email;
      document.getElementById("password").value = password;
      document.getElementById("creditCardNum").value = creditCardNum;
      $("#editCustomerModal").modal('show');
    } else if (action == "Delete") {

    }
}

function SuggestCustomerItemList(el, username) {
 var customerID = el.value;

 window.location = "CustomerSuggestions.jsp?customerID="+customerID+"&username="+username;


}
