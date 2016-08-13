<script runat="server" language="JScript">
/*
 * CKFinder
 * ========
 * http://ckfinder.com
 * Copyright (C) 2007-2010, CKSource - Frederico Knabben. All rights reserved.
 *
 * The software, this file and its contents are subject to the CKFinder
 * License. Please read the license.txt file before using, installing, copying,
 * modifying or distribute this file or part of its contents. The contents of
 * this file is part of the Source Code of CKFinder.
 */

	///
	// @package CKFinder
	// @subpackage Utils
	// @copyright CKSource - Frederico Knabben
	//

	///
	// Yep, JScript.
	// It does provide functions to easily handle time offset that VBscript doesn't
	//
	// @package CKFinder
	// @subpackage Utils
	// @copyright CKSource - Frederico Knabben
	//
/*
function getServerGMTOffset()
{
	return 0 - new Date().getTimezoneOffset();
}
*/
///
// Returns the passed date as a string formatted with regards to RFC822
//
function FormatDateRFC822( vDate )
{
	return new Date( vDate ).toGMTString().replace(/UTC$/, 'GMT') ;
}


// In VBScript we get back a string, so we can't use this.
function ParseDateRFC822( sDate )
{
	return new Date( sDate );
}

// returns true if sDate1 >= sDate2
function CompareRFC822Dates( sDate1, sDate2 )
{
	var date1 = ParseDateRFC822( sDate1 ) ;
	var date2 = ParseDateRFC822( sDate2 ) ;
	return date1 >= date2 ;
}

</script>
