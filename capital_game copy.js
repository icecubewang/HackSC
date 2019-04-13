// This allows the Javascript code inside this block to only run when the page
// has finished loading in the browser.




$( document ).ready(function() {
  	
	var country_capital_pairs = pairs
    $(function(){
        $.ajax({
		    url: "https://s3.ap-northeast-2.amazonaws.com/cs374-csv/country_capital_pairs.csv", 
		    type: "GET",
		    success: function(data){
			  var lines = data.split("\n");
			  var result = [];

			  for (var i = 1; i < lines.length; i++) {
			    var obj = {};
			    var currentLine = lines[i].split(",");

			    obj["country"] = currentLine[0];
			    obj["capital"] = currentLine[1];

			    result.push(obj);
			  }

			  // return JSON.stringify(result);
			  window.pairs = result;

		        },
		    error: function() {
		      $("#div1").html('An error has occurred');
		    }
		});
    });
		

    var ifrm = document.getElementById("map");

    var country = document.getElementById('pr2__question').innerHTML;
    ifrm.src="https://www.google.com/maps/embed/v1/place?key=AIzaSyDzeNCuoxcaBLNTEiNECAFmuSdW1uyFjOQ &maptype=satellite&q="+country;
 





  	var wrongref = firebase.database().ref();
	wrongref.on("child_added", function(snapshot){
		console.log(snapshot.val());
		var id = snapshot.key;
		var country_name = snapshot.val().country_name;
		var wrong_answer = snapshot.val().wrong_answer;
		var correct_answer = snapshot.val().correct_answer;

		var table = document.getElementsByTagName('table')[0];
		var newRow = table.insertRow(3);
		var cel1 = newRow.insertCell(0);
		var cel2 = newRow.insertCell(1);
		var cel3 = newRow.insertCell(2);


		if (wrong_answer != correct_answer) {
			newRow.style.color = "red";
			newRow.setAttribute("id", id);
			cel2.style.textDecoration = "line-through";
			// cel1.appendChild(document.createTextNode(country_name));
			var b = document.createElement("country_name");
			b.type = "button";
			b.innerHTML = country_name;
			b.style.cursor="pointer";
			cel1.appendChild(b);
			b.addEventListener("click", function(){
				ifrm.src="https://www.google.com/maps/embed/v1/place?key=AIzaSyDzeNCuoxcaBLNTEiNECAFmuSdW1uyFjOQ &maptype=satellite&q="+country_name;
			})
			cel2.appendChild(document.createTextNode(wrong_answer));
			cel3.appendChild(document.createTextNode(correct_answer));
		}
		else{
			newRow.style.color = "blue";
			let tick = document.createElement("span");
			tick.classList.add("fas");
			tick.classList.add("fa-check");

			var b = document.createElement("country_name");
			b.type = "button";
			b.innerHTML = country_name;
			b.style.cursor="pointer";
			cel1.appendChild(b);
			b.addEventListener("click", function(){
				// window.alert("ok");
				ifrm.src="https://www.google.com/maps/embed/v1/place?key=AIzaSyDzeNCuoxcaBLNTEiNECAFmuSdW1uyFjOQ &maptype=satellite&q="+country_name;
			})
			// cel1.appendChild(document.createTextNode(country_name));
			cel2.appendChild(document.createTextNode(correct_answer));
			cel3.appendChild(tick);

		}
		var btn = document.createElement("button");
		btn.type = "button";
		btn.className = "btn";
		btn.innerHTML = "Delete";
		// btn.onclick = deleteRow();
		cel3.appendChild(btn);
		btn.addEventListener("click", function(){
			newRow.remove();
			firebase.database().ref().child(id).remove();
			});

	}, function (error){ 
		console.log("error: "+ error.code);
	});

});




function randomQuestion(){
	var randomNumber = Math.floor(Math.random()*(pairs.length));
	country_name = pairs[randomNumber].country;
	document.getElementById("pr2__question").innerHTML = country_name;
	document.getElementById('pr2__answer').value = '';
	var ifrm = document.getElementById("map");
	ifrm.src="https://www.google.com/maps/embed/v1/place?key=AIzaSyDzeNCuoxcaBLNTEiNECAFmuSdW1uyFjOQ &maptype=satellite&q="+country_name;
 
}



function correctAnswer(country, answer){
	firebase.database().ref().push({
		country_name : country,
		wrong_answer : answer,
		correct_answer : answer		
	});
}


function wrongAnswer(country, answer, correct_answer){
	var newPostRef = firebase.database().ref().push()
	newPostRef.set({
		country_name : country,
		wrong_answer : answer,
		correct_answer : correct_answer
	});
}

function addRow(){

	var country = document.getElementById('pr2__question').innerHTML;
	var answer = document.getElementById('pr2__answer').value;
	// document.write(answer);
	// return;

	// var correctness = document.getElementById('pr2__submit').value;
	for (var i = pairs.length - 1; i >= 0; i--) {
		// if the answer is correct
		if (pairs[i]["country"] == country){
			if (pairs[i]["capital"] == answer){
				correctAnswer(country, answer);
				randomQuestion();
				return;				
			}
			else{	
				wrongAnswer(country, answer, pairs[i]["capital"]);
				randomQuestion();
				return;
			}
		} 
	}
}



 
$(() => 
    $("#pr2__answer").autocomplete({
      source: pairs.map(t => t.capital), // (lambda (t) (.capital t))
      minLength : 2
    })
);


$(() => 
    $( "#pr2__answer" ).keydown(function(event) {
    if (event.keyCode == 13)
        addRow();
	})
);


function chooseAll(){
	Array.prototype.slice.call(document.getElementsByTagName("tr")).forEach(tr => {
	 if (tr.style.color === "red" || tr.style.color === "blue")
	 	tr.style.display = "table-row";
	});
}

function chooseCorrect(){
	// Array.prototype.slice.call(document.getElementsByTagName("tr")).forEach(tr => if tr.style.color === "red")
	Array.prototype.slice.call(document.getElementsByTagName("tr")).forEach(tr => {
	 if (tr.style.color === "red")
	 	tr.style.display = "none";
	 else if (tr.style.color === "blue")
	 	tr.style.display = "table-row"; 
	});
}


function chooseWrong(){
	Array.prototype.slice.call(document.getElementsByTagName("tr")).forEach(tr => {
	 if (tr.style.color === "red")
	 	tr.style.display = "table-row";
	 else if (tr.style.color === "blue")
	 	tr.style.display = "none"; 
	});
}


function deleteRow(){
	document.write("delete");
}


function clearContent(){
	var table = document.getElementsByTagName('table')[0];
	while(table.rows.length > 3){
		table.deleteRow(3);
	}
	// firebase.database().ref().remove();
}
