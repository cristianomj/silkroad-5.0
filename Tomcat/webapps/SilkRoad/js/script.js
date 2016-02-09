// Ajax stuff
var element;
var xhttp;
function OnData() {
    var	elem = document.getElementById(element);
    if (xhttp.readyState != 4)	{
      elem.innerHTML = 'Loading....';
    }
    if (xhttp.readyState == 4) {
      if (xhttp.status == 200)	{
          elem.innerHTML = xhttp.responseText;
          // The ajax is done loading so we run the script from the responsetext

          eval(document.getElementById("runscript").innerHTML);
      } else {
          elem.innerHTML = "Error loading data";
      }
    }
}

// Opens a request with the url and fills the given element with the data retrieved
function sendAjax(url) {
  //alert(url);
  if (window.XMLHttpRequest) { // code for IE7+, Firefox, Chrome, Opera, Safari
      xhttp = new XMLHttpRequest();
  } else { // code for IE6, IE5
      xhttp = new ActiveXObject("Microsoft.XMLHTTP");
  }
  xhttp.open("GET", url, true);
  xhttp.onreadystatechange = OnData;
  xhttp.send();
}

function showEmployeeScreenHelp() {
  var dialog;
    dialog = new BootstrapDialog({
         title: "Screens",
          message: "EMPLOYEE"
      });
    dialog.realize();
    dialog.getModalHeader().css('background-color', 'lightgreen');
    dialog.open();
    return;
}

function showCustomerScreenHelp(page) {
  var dialog;
    dialog = new BootstrapDialog({
         title: "Screens",
          message: "Search:\n Search for all active and inactive auctions. \n\n \
                    Post:\n Post a new auction. \n\n \
                    Completed:\n Search all auctions that you have taken part in, either as a seller or a buyer."
      });
    dialog.realize();
    dialog.getModalHeader().css('background-color', 'lightgreen');
    dialog.open();
    return;
}

function showAuctionHelp() {
  var dialog = new BootstrapDialog({
       title: "Auctions",
        message: "You can bid on an auction if the auction is not expired and you are not the seller. \n\n\
                  Using the dropdown next to each auction on the table, select ''Place Bid'' and fill out \
                  the form to submit your bid.\n\n \
                  A bid history for each auction can be viewed by clicking the plus sign to the left of each \
                  auction in the table."
    });
    dialog.realize();
    dialog.getModalHeader().css('background-color', 'lightgreen');
    dialog.open();
    return;
}

function showBestSellers() {
    $("#bestSellersModal").modal('show');
}

function showItemSuggestions() {
    $("#itemSuggestionsModal").modal('show');
}

$(document).ready(function() {

	$('#indexForm').validate({
		rules: {
		 username: {
					required: true,
					maxlength:20
				},

			password: {
				required: true,
				maxlength:20
			}
		},
		highlight: function(element) {
			$(element).closest('.control-group').removeClass('success').addClass('error');
		},
		success: function(element) {
			element.text('OK!').addClass('valid')
			.closest('.control-group').removeClass('error').addClass('success');
		}
	});

	$.validator.addMethod("greaterThanEqualTo",
			function (value, element, param, msg) {
        if (value == "") {
          return true;
        }
			  var $min = $(param);
			  if (this.settings.onfocusout) {
			    $min.off(".validate-greaterThan").on("blur.validate-greaterThan", function () {
			      $(element).valid();
			    });
			  }
			  return parseFloat(value) >= parseFloat($min.val());
			}, "Reserve must be greater or equal to opening bid.");

	$('#postAuctionForm').validate({
		rules: {
		 		item: {
					required: true,
					maxlength:255
				},
        openingTime: {
          required:true
        },
				openingBid: {
          required: true,
					number:true,
					pattern: /^[0-9]{0,5}(.[0-9]{1,2})?$/
				},
				reserve: {
						number:true,
						pattern: /^[0-9]{0,5}(.[0-9]{1,2})?$/,
						greaterThanEqualTo:"#openingBid"
				}
		},
		highlight: function(element) {
			$(element).closest('.control-group').removeClass('success').addClass('error');
		}
	});

	$('#employeeRegForm').validate({
	    rules: {
	       firstName: {
	        required: true,
					maxlength:20
	       },

				lastName: {
				 required: true,
				 maxlength:20
			  },

			 username: {
		        required: true,
						maxlength:20
		      },

			  password: {
					required: true,
					maxlength:20
				},

				reenterPassword: {
					required: true,
					maxlength: 20,
					equalTo: "#password"
				},

				zipcode: {
					required:true,
					pattern: /^[0-9]{5}(\-[0-9]{5})?$/,
					minlength:5,
					maxlength:11
				},

				street: {
					required: true,
					maxlength: 150
				},

				city: {
					required: true,
					maxlength: 75
				},

	      email: {
					required: true,
	        email: true,
					maxlength:50
	      },

				telephone: {
					number:true,
					minlength:10,
					maxlength:10
				},

				ssn: {
					required:true,
					number:true,
          pattern: /^[1-9]/,
					minlength:9,
					maxlength:9
				},

				hourlyRate: {
					number:true,
					maxlength:8,
					pattern: /^[0-9]{0,5}(.[0-9]{1,2})?$/
				}
			},
			highlight: function(element) {
				$(element).closest('.control-group').removeClass('success').addClass('error');
			},
			success: function(element) {
				element.text('OK!').addClass('valid')
				.closest('.control-group').removeClass('error').addClass('success');
			}
		});

			$('#customerRegForm').validate({
		    rules: {
		       firstName: {
		        required: true,
						maxlength:20
		       },

					lastName: {
					 required: true,
					 maxlength:20
				  },

				 username: {
			        required: true,
							maxlength:20
			      },

				  password: {
						required: true,
						maxlength:20
					},

					reenterPassword: {
						required: true,
						maxlength: 20,
						equalTo: "#password"
					},

					zipcode: {
						required:true,
						pattern: /^[0-9]{5}(\-[0-9]{5})?$/,
						minlength:5,
						maxlength:11
					},

					street: {
						required: true,
						maxlength: 150
					},

					city: {
						required: true,
						maxlength: 75
					},

		      email: {
		        email: true,
						maxlength:50
		      },

					telephone: {
						number:true,
						minlength:10,
						maxlength:10
					},

					ssn: {
						required:true,
						number:true,
            pattern: /^[1-9]/,
						minlength:9,
						maxlength:9
					},

					ccn: {
						number:true,
						minlength:16,
						maxlength:16
					}
    },
		highlight: function(element) {
			$(element).closest('.control-group').removeClass('success').addClass('error');
		},
		success: function(element) {
			element.text('OK!').addClass('valid')
			.closest('.control-group').removeClass('error').addClass('success');
		}
	});




	/** Hide the "Showing x of N entires" and the "Previous .. Next" and the Search filter */
	// $('#auctionDataTable').dataTable({
  //      "bInfo" : false,
	// 		 "bPaginate": false,
	// 		 "bFilter":false,
  //  });

}); // end document.ready
