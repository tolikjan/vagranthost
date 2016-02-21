<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>PHP Vagrant Box</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css" rel="stylesheet" />
    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet">
    <style type="text/css">
        html, body {
            height: 100%;
        }
        #wrap {
            min-height: 100%;
            height: auto !important;
            height: 100%;
            margin: 0 auto -60px;
        }
        #push, #footer {
            height: 60px;
        }
        #footer {
            background-color: #f5f5f5;
        }
        @media (max-width: 767px) {
            #footer {
                margin-left: -20px;
                margin-right: -20px;
                padding-left: 20px;
                padding-right: 20px;
            }
        }
        .container {
            width: auto;
            max-width: 680px;
        }
        .container .credit {
            margin: 20px 0;
        }
        .page-header i {
            float: left;
            margin-top: -5px;
            margin-right: 12px;
        }
        table td:first-child {
            width: 300px;
        }
    </style>
</head>
<body>
<div id="wrap">
    <div class="container">
        <div class="page-header">
            <i class="fa fa-lightbulb-o fa-4x"></i>
            <h1>It works!</h1>
        </div>
        <p class="lead">
            The Virtual Machine is up and running! Hooray! Here's some additional information which you may need.
        </p>

        <h3>Included packages</h3>
        <table class="table table-striped">
            <tr>
                <td>PHP Version</td>
                <td><?php echo phpversion(); ?><p class="pull-right">Check <a href="phpinfo.php">phpinfo</a></p></td>
            </tr>
            <tr>
                <td>MySQL running</td>
                <td><?php echo $mysql_running; ?></td>
            </tr>
            <tr>
                <td>MySQL version</td>
                <td><?php echo $mysql_running; ?></td>
            </tr>
        </table>

        <h3>PHP Modules</h3>
        <table class="table table-striped">
            <tr>
                <td>Apache</td>
                <td>2.4.7</td>
            </tr>
            <tr>
                <td>MySQL</td>
                <td>5.5.47</td>
            </tr>
            <tr>
                <td>cURL</td>
                <td><?php echo (function_exists('curl_init') ? 'check' : 'remove'); ?></td>
            </tr>
            <tr>
                <td>mcrypt</td>
                <td><?php echo (function_exists('mcrypt_encrypt') ? 'check' : 'remove'); ?></td>
            </tr>
            <tr>
                <td>gd</td>
                <td><?php echo (function_exists('imagecreate') ? 'check' : 'remove'); ?></td>
            </tr>
            <tr>
                <td>xDebug</td>
                <td>2.2.3</td>
            </tr>
        </table>

        <h3>MySQL credentials</h3>
        <table class="table table-striped">
            <tr>
                <td>Hostname</td>
                <td>localhost</td>
            </tr>
            <tr>
                <td>Username</td>
                <td>root</td>
            </tr>
            <tr>
                <td>Password</td>
                <td>root</td>
            </tr>
            <tr>
                <td colspan="2"><em>Note: External access is enabled! Just use
                    <strong><?php echo $_SERVER["HTTP_HOST"] ?></strong> as host.</em></td>
            </tr>
        </table>

        <h3>PHPMyAdmin</h3>
        <table class="table table-striped">
            <tr>
                <td>URL</td>
                <td>http://<?php echo $_SERVER["HTTP_HOST"] ?>/phpmyadmin</td>
            </tr>
            <tr>
                <td>Username</td>
                <td>root</td>
            </tr>
            <tr>
                <td>Password</td>
                <td>root</td>
            </tr>
        </table>

        <h3>Extra tools</h3>
        <table class="table table-striped">
            <tr>
                <td>Git</td>
                <td>v1.9.1 with tig tool</td>
            </tr>
            <tr>
                <td>Composer</td>
                <td>v1.0-dev</td>
            </tr>
            <tr>
                <td>PHPMyAdmin</td>
                <td>4.0.10deb1</td>
            </tr>
        </table>
    </div>

    <div id="push"></div>
</div>

<div id="footer">
    <div class="container">
        <p class="muted credit">
            <div class="pull-left">
                <a href="https://github.com/tolikjan/vagranthost" target="_blank">
                    Vagrant Box with LAMP stack
                </a> by <a href="https://github.com/tolikjan" target="_blank">tolikjan</a>.
            </div>
        </p>
    </div>
</div>
</body>
</html>
