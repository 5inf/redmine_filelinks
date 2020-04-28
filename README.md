Redmine Filelinks Macro Plugin
==================================

This macro provides means for propperly formatting windows file links

Requirements
------------

Redmine 3.0.x, 3.1.x, 4.0.x or 4.1.x
Other versions are not tested but may work.

Installation
------------
1. Download archive and extract to /your/path/to/redmine/plugins/
2. Restart Redmine

Login to Redmine and go to Administration->Plugins. You should now see 'Redmine Filelinks'. Enjoy!

Usage
------------

### filelink macro

This macro provides means for propperly formatting and displaying windows file links.
The links provide a copy button to copy the link text into the clipboard by a single click.

For Chromium based browsers (Google Chorme, Microsoft Edge) local file access can be allowed
(ideally only restricted to really trustworthy domains)	by installing e.g. the
"Enable local file links" browser plugin by "Takashi Sugimoto (tksugimoto)"
https://chrome.google.com/webstore/detail/enable-local-file-links/nikfmfgobenbhmocjaaboihbeocackld
	
For Firefox 
...

For Mozilla
...

Syntax:

	{{filelink(LINKTARGET[,separate=SEPARATE)}}
	SEPARATE = Set to true if you want a separate output for the file and folder target
  
Examples:

	{{filelink(\serverolder)}}
	{{filelink(\serverolderile.ext)}}
	{{filelink(\serverolderile.ext,separate=true)}}
