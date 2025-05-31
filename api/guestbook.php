<?php
/*
 * This file is part of paltepuk.
 *
 * Copyright (c) 2025 ona-li-toki-e-jan-Epiphany-tawa-mi
 *
 * paltepuk is free software: you can redistribute it and/or modify it under the
 * terms of the GNU Affero General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 *
 * paltepuk is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
 * details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with paltepuk. If not, see <https://www.gnu.org/licenses/>.
 */

/*
 * Guestbook API endpoint.
 *
 * POST /api/guestbook.php - submit guestbook entry.
 */

// TODO add rate limiting.
// TODO make redirect back to correct language.

////////////////////////////////////////////////////////////////////////////////
// Configuration                                                              //
////////////////////////////////////////////////////////////////////////////////

// API storage directory.
// Set to current directory when debugging with 'php -S <url>'.
$storage = 'cli-server' === php_sapi_name() ? '' : '/var/lib/paltepuk-api/';

// Where to store guestbook submissions.
$submissions_directory = "${storage}guestbook/";

// Browser redirect settings.
$redirect_time_s = 5;
$redirect_to     = "/guestbook";

////////////////////////////////////////////////////////////////////////////////
// Utilities                                                                  //
////////////////////////////////////////////////////////////////////////////////

/**
 * Gets a field from the POST request, limiting it to maximum_length, and
 * trimming whitespaces.
 */
function get_post(string $field, int $maximum_length): string {
    $value = $_POST[$field] ?? "";
    if (!is_string($value)) $value = "";
    return trim(mb_substr($value, 0, $maximum_length));
}

/**
 * Generates a simple, machine-readable key-value pair for writing to a file.
 */
function generate_kv_string(string $key, string $value): string {
    $length = strlen($value);
    return 0 < $length ? ":$key $length\n$value\n" : '';
}

////////////////////////////////////////////////////////////////////////////////
// Handler                                                                    //
////////////////////////////////////////////////////////////////////////////////

// Response to display to client.
$_response = '';

/** @psalm-suppress PossiblyUndefinedArrayOffset - false positive. */
if ('POST' !== $_SERVER['REQUEST_METHOD']) {
    http_response_code(405);
    $_response = 'ERROR: 405 Method Not Allowed';
    goto lfinish;
}

// Form data.
$name = get_post('name', 256);
if (0 === strlen($name)) $name = 'rando';
$websites = get_post('websites', 1024);
$message  = get_post('message',  4096);
if (0 === strlen($message)) {
    http_response_code(400); // Bad Request.
    $_response = 'ERROR: no message supplied in guestbook submission';
    goto lfinish;
}

if (!file_exists($submissions_directory) && !mkdir($submissions_directory)) {
    http_response_code(500); // Internal Server Error.
    $_response = 'ERROR: could not save guestbook submission';
    goto lfinish;
}

$submission       = generate_kv_string('name', $name);
$submission      .= generate_kv_string('websites', $websites);
$submission      .= generate_kv_string('message', $message);
$submission      .= generate_kv_string('date', date("F j, Y"));
$submission_path  = $submissions_directory.md5($submission);
if (!file_exists($submission_path)) {
    if (false === file_put_contents($submission_path, $submission)) {
        http_response_code(500); // Internal Server Error.
        $_response = 'ERROR: could not save guestbook submission';
        goto lfinish;
    }
} else {
    http_response_code(429); // Too Many Requests.
    $_response = 'ERROR: guestbook submission already exists';
    goto lfinish;
}

http_response_code(201); // Created.
$_response = 'Saved guestbook submission successfully';

lfinish: ?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta http-equiv="refresh" content=<?php echo("\"$redirect_time_s;url=$redirect_to\""); ?> />
  </head>
  <body>
    <p><?php echo($_response); ?></p>
    <p><?php echo("Redirecting to <a href=\"$redirect_to\">$redirect_to</a> in $redirect_time_s second(s)"); ?></p>
  </body>
</html>
