<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>PHP Vagrant Box</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://netdna.bootstrapcdn.com/font-awesome/3.1.1/css/font-awesome.min.css" rel="stylesheet" />
    <style type="text/css">
        html, body {
            height: 100%;
            min-width: 580px;
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
            max-width: 740px;
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
            <i class="icon-spinner icon-spin icon-3x"></i>
            <h1>It works!</h1>
        </div>
        <p class="lead">
            The Virtual Machine is up and running! Hooray! Here some additional information which you may need.
        </p>

        <h3>Included packages</h3>
        <table class="table table-striped">
            <tr>
                <td>PHP Version</td>
                <td><?php echo phpversion(); ?><p class="pull-right">Check <a href="phpinfo.php">phpinfo</a></p></td>
            </tr>
            <tr>
                <td>MySQL version</td>
                <td>
                    <?php
                        $mysqli = new mysqli("localhost", "root", "root");
                        /* Check the connection */
                        if (mysqli_connect_errno()) {
                            printf("Connect failed: %s\n", mysqli_connect_error());
                            exit();
                        }
                        /* Server version */
                        printf($mysqli->server_info);
                        /* Close connection */
                        $mysqli->close();
                    ?>
                </td>
                <tr>
                    <td>Apache</td>
                    <td><?php echo apache_get_version(); ?></td>
                </tr>
            </tr>
        </table>

        <h3>PHP Modules</h3>
        <table class="table table-striped">
            <tr>
                <td>cURL</td>
                <td>
                <?php
                    /* Get the array with info about curl */
                    $version = curl_version();
                    /* Check curl possibilities */
                    $bitfields = Array(
                      'CURL_VERSION_IPV6',
                      'CURL_VERSION_KERBEROS4',
                      'CURL_VERSION_SSL',
                      'CURL_VERSION_LIBZ',
                    );
                    foreach($bitfields as $feature)
                    {
                        echo $feature . ($version['features'] & constant($feature) ? ' — present' : ' — not present');
                        echo "</ br>";
                        echo PHP_EOL;
                    }
                    ?>
                </td>
            </tr>
            <tr>
                <td>mcrypt</td>
                <td>
                    <?php
                        if(function_exists("mcrypt_encrypt")) {
                            echo "mcrypt is present";
                        } else {
                            echo "mcrypt isn't present";
                        }
                        ?>
                </td>
            </tr>
            <tr>
                <td>gd</td>
                <td>
                    <?php
                        $gdInfoArray = gd_info();
                        foreach ($gdInfoArray as $key => $value) {
                            echo $key . "  |  " .  $value . "<br />";
                        }
                        ?>
                </td>
            </tr>
            <tr>
                <td>xDebug</td>
                <td>
                    <?php
                        exec('php -v | grep -i "xdebug"', $xdebug_version);
                        echo $xdebug_version[0];
                        ?>
                </td>
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
                <td>
                    <?php
                        exec('git --version', $git_version);
                        echo $git_version[0];
                        ?>
                </td>
            </tr>
            <tr>
                <td>Composer</td>
                <td><?php
                    exec('composer -V', $composer_version);
                    echo $composer_version[0];
                    ?>
                </td>
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
