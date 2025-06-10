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

////////////////////////////////////////////////////////////////////////////////
// Configuration                                                              //
////////////////////////////////////////////////////////////////////////////////

// API storage directory. Set to current directory when debugging with:
//   php -S <url>
$storage = 'cli-server' === php_sapi_name() ? '' : '/var/lib/paltepuk-api/';
// Where to store guestbook submissions.
$submissions_directory = "{$storage}guestbook/";

$redirect_time_s = 5;

$toki_pona_css = "/toki-pona.min.css";

////////////////////////////////////////////////////////////////////////////////
// i18n                                                                       //
////////////////////////////////////////////////////////////////////////////////

$en_i18n_map = [
    'error.already_submitted' => 'ERROR: guestbook submission already submitted',
    'error.no_message'        => 'ERROR: no message supplied in guestbook submission',
    'error.save_fail'         => 'ERROR: could not save guestbook submission',
    'redirect.message'        => 'Redirecting to <a href="%s">%s</a> in %d second(s)',
    'redirect.to'             => '/guestbook',
    'save_success'            => 'Saved guestbook submission successfully',
];

$tok_i18n_map = [
    'error.already_submitted' => 'ike li kama: li kama jo e toki sina sama lon tenpo pini',
    'error.no_message'        => 'ike li kama: toki sina li ala anu lon ala',
    'error.save_fail'         => 'ike li kama: li ken ala poki e toki sina',
    'redirect.message'        => 'ilo lukin pi lipu linluwi li tawa <a href="%s">%s</a> lon tenpo Sekon %d',
    'redirect.to'             => '/tok/guestbook',
    'save_success'            => 'li poki pona e toki sina',
];

$language_i18n_map = [
    'en'  => $en_i18n_map,
    'tok' => $tok_i18n_map,
];

// Default to english.
$language = 'en';
$i18n     = $en_i18n_map;

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
$response = '';

/** @psalm-suppress PossiblyUndefinedArrayOffset - false positive. */
if ('POST' !== $_SERVER['REQUEST_METHOD']) {
    http_response_code(405);
    $response = 'ERROR: 405 Method Not Allowed';
    goto lfinish;
}

// Language selection.
$language = get_post('language', 3);
if (!isset($language_i18n_map[$language])) {
    http_response_code(400); // Bad Request.
    $response = "ERROR: unknown language code '$language'";
    goto lfinish;
}
$i18n = $language_i18n_map[$language];

// Form data.
$name     = get_post('name', 256);
if (0 === strlen($name)) $name = 'rando';
$websites = get_post('websites', 1024);
$message  = get_post('message',  4096);
if (0 === strlen($message)) {
    http_response_code(400); // Bad Request.
    $response = $i18n['error.no_message'];
    goto lfinish;
}

if (!file_exists($submissions_directory) && !mkdir($submissions_directory)) {
    http_response_code(500); // Internal Server Error.
    $response = $i18n['error.save_fail'];
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
        $response = $i18n['error.save_fail'];
        goto lfinish;
    }
} else {
    http_response_code(429); // Too Many Requests.
    $response = $i18n['error.already_submitted'];
    goto lfinish;
}

http_response_code(201); // Created.
$response = $i18n['save_success'];

lfinish:
$redirect_to = $i18n['redirect.to'];
?>
<!DOCTYPE html>
<html lang=<?php echo ("\"$language\"");?>>
  <head>
    <meta http-equiv="refresh" content=<?php echo("\"$redirect_time_s;url=$redirect_to\""); ?> />
    <?php if ("tok" === $language) {
        echo("<link rel=\"stylesheet\" type=\"text/css\" href=\"$toki_pona_css\">\n");
    } ?>
  </head>
  <body>
    <p><?php echo($response); ?></p>
    <p><?php
        /**
         * @psalm-suppress PossiblyFalseArgument - false positive.
         * @psalm-suppress PossiblyNullArgument  - false positive.
         */
        echo(
            mb_ereg_replace('%d', "$redirect_time_s",
            mb_ereg_replace('%s', $redirect_to,
            $i18n['redirect.message']
        )));
    ?></p>
  </body>
</html>
