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
 * Guestbook submission API endpoint.
 *
 * POST /api/guestbook-submit.php - submit guestbook entry.
 */

// TODO add rate limiting.

////////////////////////////////////////////////////////////////////////////////
// Configuration                                                              //
////////////////////////////////////////////////////////////////////////////////

// Where to store the guestbook submissions file.
// Set to current directory when debugging with 'php -S <url>'.
$storage = 'cli-server' === php_sapi_name() ? '' : '/var/lib/paltepuk-api/';

// Browser redirect settings.
$redirect_time_s = 5;
$redirect_to     = "/guestbook";

////////////////////////////////////////////////////////////////////////////////
// Utilities                                                                  //
////////////////////////////////////////////////////////////////////////////////

/**
 * Gets a field from the POST request, limiting it to maximum_length.
 */
function get_post(string $field, int $maximum_length): string {
    $value = $_POST[$field] ?? "";
    if (!is_string($value)) $value = "";
    return mb_substr($value, 0, $maximum_length);
}

/**
 * @param resource $file
 */
function write_field($file, string $field, string $data): void {
    fwrite($file, ":$field ".(string)strlen($data)."\n");
    fwrite($file, "$data\n");
}

////////////////////////////////////////////////////////////////////////////////
// Handler                                                                    //
////////////////////////////////////////////////////////////////////////////////

# Response to display to client.
$_response = '';

/** @psalm-suppress PossiblyUndefinedArrayOffset - false positive. */
if ('POST' !== $_SERVER['REQUEST_METHOD']) {
    http_response_code(405);
    $_response = 'ERROR: 405 Method Not Allowed';
    goto lfinish;
}

$name = get_post('name', 256);
if (0 === strlen($name)) $name = 'rando';
$websites = get_post('websites', 1024);
$message  = get_post('message',  4096);
if (0 === strlen($message)) {
    http_response_code(400); // Bad Request.
    $_response = 'ERROR: no message supplied in guestbook submission';
    goto lfinish;
}

$file = fopen($storage.'guestbook.txt', 'a');
if (!$file) {
    http_response_code(500); // Internal Server Error.
    $_response = 'ERROR: could not save guestbook submission';
    goto lfinish;
}
write_field($file, 'name', $name);
if (0 !== strlen($websites)) write_field($file, 'websites', $websites);
write_field($file, 'message', $message);
write_field($file, 'date', date("F j, Y"));
fwrite($file, "---\n");
fclose($file);

http_response_code(301); // Moved Permanently.
$_response = 'Saved guestbook submission successfully';
lfinish:

?><!DOCTYPE html>
<html lang="en">
  <head>
    <meta http-equiv="refresh" content=<?php echo("\"$redirect_time_s;url=$redirect_to\""); ?> />
  </head>
  <body>
    <p><?php echo($_response); ?></p>
    <p><?php echo("Redirecting to $redirect_to in $redirect_time_s second(s)"); ?></p>
  </body>
</html>
