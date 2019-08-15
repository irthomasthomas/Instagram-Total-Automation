<script>
                // Send requests sequentially so as to not overload the server
                var update = function(){
                    var xhttp = new XMLHttpRequest();
                    xhttp.onreadystatechange = function() {
                        if (xhttp.readyState == 4 && xhttp.status == 200) {
                            document.getElementById("mouse").innerHTML = xhttp.responseText;
                            setTimeout(update, 1000);
                        }
                    };
                    xhttp.open("GET", "mouse", true);
                    xhttp.send();
                }

                var updateScreen = function(){
                    var xhttp = new XMLHttpRequest();
                    xhttp.onreadystatechange = function() {
                        if (xhttp.readyState == 4 && xhttp.status == 200) {
                            document.getElementById("screen").innerHTML = xhttp.responseText;
                            setTimeout(updateScreen, 1000);
                        }
                    };
                    xhttp.open("GET", "screen", true);
                    xhttp.send();
                }

                var updateTotals = function(){
                    var xhttp = new XMLHttpRequest();
                    xhttp.onreadystatechange = function() {
                        if (xhttp.readyState == 4 && xhttp.status == 200) {
                            document.getElementById("totals").innerHTML = xhttp.responseText;
                            setTimeout(updateTotals, 1000);                            
                        }
                    };
                    xhttp.open("GET","totals",true);
                    xhttp.send();
                }

                setTimeout(updateTotals, 1000);
                setTimeout(update, 1000);
                setTimeout(updateScreen, 1000);

            </script>