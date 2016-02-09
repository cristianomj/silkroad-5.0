/**
* Use this script for any jsp file which will have a table with id 'auctionDataTable'
* being populated by a search by name and search by type function
*/

/** On startup we want the bid history to be hidden, and then expanded when the user
 clicks the + button */
$(document).ready(function() {
    // Find arg must match the closest tag after <td colspan="3">
    $("td[colspan=5]").find("div").hide();
    $("#auctionDataTable").click(function(event) {
        event.stopPropagation();
        var target = $(event.target);
        var plus = "<span class=\"glyphicon glyphicon-plus\" aria-hidden=\"true\"></span>";
        var minus = "<span class=\"glyphicon glyphicon-minus\" aria-hidden=\"true\"></span>";
        // Without this check we run the risk of editing the tables on non + and -
        if (target.html().contains("+") || target.html().contains("-")) {
            if (target.closest("td").attr("colspan") > 1 ) {
                slideUp();
                target.closest("tr").prev().find("td:first").html(minus);
            } else {
                // Find arg must match the same that we hid
                target.closest("tr").next().find("div").slideToggle();
                var path = target.closest("tr").find("td:first").find("button:first");
                if (path.html().contains(plus)) {
                    path.html(minus);
                }
                else {
                    path.html(plus);
                }
           }
        }
    });
}); // $(document).ready(function()

// The var 'element' references the global var in script.js
function searchByType(usage) {
  var url = "getItems.jsp";
  var type = document.getElementById("itemType");
  type = type.options[type.selectedIndex].text;

  if (type == "-- Show all --") {
    type = "";
  }

  var getUrl = "?usage="+usage+"|type&type="+type;
  element = "auctionData";
  sendAjax(url+getUrl);
}

function searchByName(usage) {
  element = "auctionData";
  var url = "getItems.jsp";
  var name1 = document.getElementById("itemName1").value;
  var name2 = document.getElementById("itemName2").value;
  var name3 = document.getElementById("itemName3").value;
  var getUrl = "?usage="+usage+"|name&all=1&name1="+name1+"&name2="+name2+"&name3="+name3;
  sendAjax(url+getUrl);
}

function searchBySeller(usage) {
  var url = "getItems.jsp";
  var seller = document.getElementById("sellerUsername");
  seller = seller.options[seller.selectedIndex].text;

  if (seller == "-- Show all --") {
    seller = "";
  }

  var getUrl = "?usage="+usage+"|seller&seller="+seller;
  element = "auctionData";
  sendAjax(url+getUrl);
}

function placeBid(el, bid) {
  var validDecimal = bid.match(/^\d*(?:\.\d{0,2}){0,1}$/);
  if (!validDecimal) {
     var dialog = new BootstrapDialog({
          title: "Error",
           message: "Please enter a valid dollar value, i.e. 15.50"
       });
       dialog.realize();
       dialog.getModalHeader().css('background-color', 'lightgreen');
       dialog.open();
       return;
   }
  // The auction to bid on
  var auctionID = el.value;
  
  $.ajax({
        url: 'placeBid.jsp',
        data: {auction: auctionID, bid: bid},
        success: function(){
            location.reload(true)
        }
    });
}

function showItemDetails(name, type, description, year, numCopies) {
  if (description = "null") {
    description = "No description";
  }
  var dates = year.split("-");
  year = dates[0];
  var dialog = new BootstrapDialog({
       title: name,
       message: $('<table class="table"><tbody> \
                      <tr> \
                        <th>Type</th> \
                          <td>' + type + '</td> \
                      </tr> \
                      <tr> \
                        <th>Year</th> \
                          <td>' + year + '</td> \
                      </tr> \
                    <tr> \
                      <th>Description</th> \
                      <td>' + description + '</td> \
                    </tr> \
                    <tr> \
                      <th>Number of Copies</th> \
                      <td>' + numCopies + '</td> \
                    </tr> \
                    </tbody> </table>')
    });
    dialog.realize();
    dialog.getModalHeader().css('background-color', 'lightgreen');
    dialog.open();
}

function auctionAction(el) {
	document.getElementById("auctionID").value = el.value;
	$("#bidModal").modal('show');
	
    /*var action = el.options[el.selectedIndex].text;

    // This is the auction we will be making the action on
    var auctionID = el.options[el.selectedIndex].value;
    if (action == "Place Bid") {
      document.getElementById("auctionID").value = auctionID;
      $("#bidModal").modal('show');
    } else if (action == "viewSeller") {
      // TODO?
    }*/
}
