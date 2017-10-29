/*
==============================================================================
Description : Auto reload the current web page if the underlying file changes
Author(s)   : Michael Hucka <mhucka@caltech.edu>
Organization: California Institute of Technology
Date created: June 2014
Source      : https://github.com/mhucka/pangolin-notebook
==============================================================================

Portions of this code were originally created by Shaun Fuchs and posted to
https://kiwidev.wordpress.com/2011/07/14/auto-reload-page-if-html-changed/
An archived copy of that page is available in the following locations:

  https://archive.is/4I5VU
  https://web.archive.org/web/20110721013851/https://kiwidev.wordpress.com/2011/07/14/auto-reload-page-if-html-changed/

The code was provided by the author in BitBucket and GitHub:

  https://bitbucket.org/diffused/html-crc-reload
  https://github.com/diffused/html-crc-reload

No license is indicated in the original code.  I modified the original code
in the following ways:

  June 2014:
  - Changed to use a different, hopefully faster crc32 function.
  - Reformatted the code.
  - Commented out some code that looked questionable.
  - Changed the polling interval.

  Oct 2017:
  - Change to only run on local host.

At this point, it would be fair to say that the only remaining portions of
Fuchs' code are parts of the check() function and the overall idea of this
file.  The CRC code came from a Stack Overflow posting by user "Alex" at
https://stackoverflow.com/a/18639999/743730 as it existed around June 2014.
The S.O. terms of use (https://meta.stackexchange.com/questions/272956) are
that code is to be attributed and assumed to be licensed under the MIT license.

-----------------------------------------------------------------------------
Here is the original file header for html-crc-reload.js from S. Fuchs.

  crc-reload is a script to auto reload the current page when you save the html.
  Requires jquery.
  Usage: 
  Simply include this js file in your html page.
  It will ajax GET poll the current page every second and if the html is different, reload itself.
  Version 0.1 - Initial release
  Thanks to Andrea Ercolino for providing the javascript crc32 functionality
  http://noteslog.com/post/crc32-for-javascript/
-----------------------------------------------------------------------------
*/

/* Polling period, in seconds. */
var cacheRefreshPeriod = 2;

/* The following hooks in the auto-reload code. */
$(function() {
    if (runningLocally()) {
        check(true);
        setInterval('check()', 1000 * cacheRefreshPeriod);
    }
});

/* Returns true if the page is loaded from the local host. */
function runningLocally() {
    return (location.hostname === "localhost"
            || location.hostname === "127.0.0.1"
            || location.hostname === ""
            || window.location.protocol === "file:");
}

/* AJAX code to reload the page if its CRC value changes. */
var previousCrc = 0;

function check() {
    $.ajax({
	type: 'GET',			
        cache: false,
	url: window.location.pathname,					
	success: function(data) {						
	    if (previousCrc == 0) {	
		previousCrc = crc32(data);
		return;
	    }
	    if (crc32(data) != previousCrc) {
		window.location.reload();
	    } 
	},
	dataType: 'html'
    });
}	

/* Improved crc32 function from http://stackoverflow.com/a/18639999 */

var makeCRCTable = function() {
    var c;
    var crcTable = [];
    for (var n = 0; n < 256; n++) {
        c = n;
        for (var k = 0; k < 8; k++) {
            c = ((c&1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1));
        }
        crcTable[n] = c;
    }
    return crcTable;
}

var crc32 = function(str) {
    var crcTable = window.crcTable || (window.crcTable = makeCRCTable());
    var crc = 0 ^ (-1);

    for (var i = 0; i < str.length; i++ ) {
        crc = (crc >>> 8) ^ crcTable[(crc ^ str.charCodeAt(i)) & 0xFF];
    }

    return (crc ^ (-1)) >>> 0;
};
