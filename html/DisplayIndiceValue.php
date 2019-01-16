<!doctype html>
<html lang="en">
<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="icon" href="img/favicon.png" type="image/png">
<title>US STOCK PROJECT</title>
<!-- Bootstrap CSS -->
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="vendors/linericon/style.css">
<link rel="stylesheet" href="css/font-awesome.min.css">
<link rel="stylesheet" href="vendors/owl-carousel/owl.carousel.min.css">
<link rel="stylesheet" href="vendors/lightbox/simpleLightbox.css">
<link rel="stylesheet" href="vendors/nice-select/css/nice-select.css">
<link rel="stylesheet" href="vendors/animate-css/animate.css">
<!-- main css -->
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/responsive.css">
</head>
<body>

<!--================Header Menu Area =================-->
<header class="header_area">
<div class="main_menu">
<nav class="navbar navbar-expand-lg navbar-light">
<div class="container">
<!-- Brand and toggle get grouped for better mobile display -->
<a class="navbar-brand logo_h" href="http://ugrad.cs.jhu.edu/~nju1/HomePage.html"><h1 style="color: #5e9ca0;">US Stock Database</h1></a>
<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
<span class="icon-bar"></span>
<span class="icon-bar"></span>
<span class="icon-bar"></span>
</button>
<!-- Collect the nav links, forms, and other content for toggling -->
<div class="collapse navbar-collapse offset" id="navbarSupportedContent">
<ul class="nav navbar-nav menu_nav justify-content-center">
<li class="nav-item"><a class="nav-link" href="http://ugrad.cs.jhu.edu/~nju1/HomePage.html">Home</a></li>
<li class="nav-item"><a class="nav-link" href="http://ugrad.cs.jhu.edu/~nju1/Introduction.html">Introduction</a></li>
<li class="nav-item"><a class="nav-link" href="http://ugrad.cs.jhu.edu/~nju1/Specialization.html">Specialization</a></li>
<li class="nav-item"><a class="nav-link" href="http://ugrad.cs.jhu.edu/~nju1/Future.html">Future Work</a></li>
<li class="nav-item"><a class="nav-link" href="http://ugrad.cs.jhu.edu/~nju1/contact.html">Contact</a></li>
</ul>
</div>
</div>
</nav>
</div>
</header>
<!--================Header Menu Area =================-->

<?php
    include 'conf.php';
    include 'open.php';
    
    // PHP code just started
    ini_set('error_reporting', E_ALL);
    ini_set('display_errors', true);
    // display errors
    
    $mysqli = new mysqli("dbase.cs.jhu.edu", "nju1", "maebfgpxup", "cs41518_nju1_db");
    // ********* Remember to use your MySQL username and password here ********* //
    
    if (mysqli_connect_errno()) {
        printf("Connect failed: %s<br>", mysqli_connect_error());
        exit();
    }
    
    $dataPoints = array();
    
    $SymbolID = $_POST['SymbolID'];
    $Beginning = $_POST['Beginning'];
    $B_month = substr($Beginning, 0,2);
    $B_day = substr($Beginning, 3,2);
    $B_year = substr($Beginning, 6,4);
    
    $Ending = $_POST['Ending'];
    $E_month = substr($Ending, 0,2);
    $E_day = substr($Ending, 3,2);
    $E_year = substr($Ending, 6,4);
    
    $StartDate = $B_year.'-'.$B_month.'-'.$B_day;
    $EndDate = $E_year.'-'.$E_month.'-'.$E_day;
    
    $query = "CALL INDICEINFORMATION('".$SymbolID."','".$StartDate."','".$EndDate."');";
    $order = 0;
    
    echo "<br>";
    echo "General Information About ".$SymbolID;
    if ($mysqli->multi_query($query)) {
        do {
            if ($result = $mysqli->store_result()) {
                $column = $result -> fetch_fields();
                if ($order == 0) {
                    echo "<table border=1>\n";
                    echo "<tr>";
                    foreach($column as $index) {
                        echo "<td>{$index->name}</td>";
                    }
                    echo "</tr>";
                }
                
                while ($row = $result->fetch_row()) {
                    if ($order == 0) {
                        echo "<tr>";
                        for ($i = 0; $i < count($row); $i++) {
                            echo "<td>{$row[$i]}</td>";
                        }
                        echo "</tr>";
                    }
                    if ($order == 1) {
                        array_push($dataPoints, array("y" => $row[4], "label" => $row[0]));
                    }
                }
                
                if ($order == 0) {
                    echo "</table><br>";
                }
                $result->close(); }
            $order++;
        } while ($mysqli->next_result());
    } else {
        printf("<br>Error: %s\n", $mysqli->error);
    }
    ?>
</body>

<!DOCTYPE HTML>
<html>
<head>
<script>
window.onload = function () {
    
    var chart = new CanvasJS.Chart("chartContainer", {
                                   title: {
                                   text: "Indice Value Trends On Selected Time Periods"
                                   },
                                   axisY: {
                                   title: "Indice Valued"
                                   },
                                   data: [{
                                   type: "line",
                                   options: {
                                   layout: {
                                   padding: {
                                   left: 50,
                                   right: 0,
                                   top: 0,
                                   bottom: 0
                                   }
                                   }
                                   },
                                   dataPoints: <?php echo json_encode($dataPoints, JSON_NUMERIC_CHECK); ?>
                                   }]
                                   });
    chart.render();
    
}
</script>
</head>
<body>
<div id="chartContainer" style="height: 370px; width: 60%;"></div>
<script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
</body>
</html>

<body>
<?php
//    include 'conf.php';
//    include 'open.php';
    
    // PHP code just started
    ini_set('error_reporting', E_ALL);
    ini_set('display_errors', true);
    // display errors
    
    $mysqli = new mysqli("dbase.cs.jhu.edu", "nju1", "maebfgpxup", "cs41518_nju1_db");
    // ********* Remember to use your MySQL username and password here ********* //
    
    if (mysqli_connect_errno()) {
        printf("Connect failed: %s<br>", mysqli_connect_error());
        exit();
    }
    
//    $SymbolID = $_POST['SymbolID'];
//    $Beginning = $_POST['Beginning'];
//    $B_month = substr($Beginning, 0,2);
//    $B_day = substr($Beginning, 3,2);
//    $B_year = substr($Beginning, 6,4);
//
//    $Ending = $_POST['Ending'];
//    $E_month = substr($Ending, 0,2);
//    $E_day = substr($Ending, 3,2);
//    $E_year = substr($Ending, 6,4);
//
//    $StartDate = $B_year.'-'.$B_month.'-'.$B_day;
//    $EndDate = $E_year.'-'.$E_month.'-'.$E_day;
//
    $query = "CALL INDICEINFORMATION('".$SymbolID."','".$StartDate."','".$EndDate."');";
    $order = 0;
    echo "<br>";
    echo "<br>";
    echo "<br>";
    echo "Daily Price Information Of ".$SymbolID;
    if ($mysqli->multi_query($query)) {
        do {
            if ($result = $mysqli->store_result()) {
                $column = $result -> fetch_fields();
                if ($order == 1) {
                    echo "<table border=1>\n";
                    echo "<tr>";
                    foreach($column as $index) {
                        echo "<td>{$index->name}</td>";
                    }
                    echo "</tr>";
                }
                
                while ($row = $result->fetch_row()) {
                    if ($order == 1) {
                        echo "<tr>";
                        for ($i = 0; $i < count($row); $i++) {
                            echo "<td>{$row[$i]}</td>";
                        }
                        echo "</tr>";
                    }
                }
                
                if ($order == 1) {
                    echo "</table><br>";
                }
                $result->close(); }
            $order++;
        } while ($mysqli->next_result());
    } else {
        printf("<br>Error: %s\n", $mysqli->error);
    }
    ?>
</body>
