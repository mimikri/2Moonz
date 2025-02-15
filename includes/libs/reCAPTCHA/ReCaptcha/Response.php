<?php
/**
 * This is a PHP library that handles calling reCAPTCHA.
 *
 * @copyright Copyright (c) 2015, Google Inc.
 * @link      http://www.google.com/recaptcha
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

namespace ReCaptcha;

/**
 * The response returned from the service.
 */
class Response
{
    /**
     * Build the response from the expected JSON returned by the service.
     *
     * @param string $json
     * @return \ReCaptcha\Response
     */
    public static function fromJson($json): \ReCaptcha\Response
    {
        $responseData = json_decode($json, true);

        if (!$responseData) {
            return new Response(false, ['invalid-json']);
        }

        $hostname = $responseData['hostname'] ?? null;

        if (isset($responseData['success']) && $responseData['success'] == true) {
            return new Response(true, [], $hostname);
        }

        if (isset($responseData['error-codes']) && is_array($responseData['error-codes'])) {
            return new Response(false, $responseData['error-codes'], $hostname);
        }

        return new Response(false, [], $hostname);
    }

    /**
     * Constructor.
     *
     * @param boolean $success
     * @param array $errorCodes
     * @param string $hostname
     */
    public function __construct(
        /**
         * Success or failure.
         */
        private $success,
        /**
         * Error code strings.
         */
        private readonly array $errorCodes = [],
        /**
         * The hostname of the site where the reCAPTCHA was solved.
         */
        private $hostname = null
    )
    {
    }

    /**
     * Is success?
     *
     * @return boolean
     */
    public function isSuccess()
    {
        return $this->success;
    }

    /**
     * Get error codes.
     *
     * @return array
     */
    public function getErrorCodes()
    {
        return $this->errorCodes;
    }

    /**
     * Get hostname.
     *
     * @return string
     */
    public function getHostname()
    {
      return $this->hostname;
    }
}
