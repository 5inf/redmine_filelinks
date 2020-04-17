# encoding: utf-8

require 'redmine'
#require 'uri'

Redmine::Plugin.register :redmine_filelinks do

	name 'Redmine filelinks plugin'
	author '5inf'
	description 'This macro provides means for propperly formatting windows file links'
	version '0.0.0'
	url 'https://github.com/5inf/redmine_wikiforms'
	author_url 'https://github.com/5inf/'

	Redmine::WikiFormatting::Macros.register do
		desc <<-DESCRIPTION
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

Syntax
	{{filelink(LINKTARGET[,separate=SEPARATE)}}
	SEPARATE = Set to true if you want a separate output for the file and folder target
Examples
	{{filelink(\\server\folder)}}
	{{filelink(\\server\folder\file.ext)}}
	{{filelink(\\server\folder\file.ext,separate=true)}}
DESCRIPTION

		macro :filelink do |obj, args, text|
			args, options = extract_macro_options(args, :separate)

			separate=false
			if(options[:separate] == 'true')
				separate= true
			end
			filefound = false
			filename= ""
			filetarget=""
			foldername=""
			foldertarget=""

			linktext	= text || "\\\\localhost\\c\\"
			linktarget = "file://"+linktext.gsub('\\','/')

			linktarget = URI.encode(linktarget)
			linktextEncoded = linktext.gsub('\\','/')

			out = "".html_safe

			re = /(^.*[\\])(.*\.[^\\]+)$/m

			# Print the match result
			linktext.match(re) do |match|
				foldername=match[1].to_s
				filename= match[2].to_s
				filefound=true
				foldertarget="file://"+foldername.gsub('\\','/')
				foldertarget=URI.encode(foldertarget)
				foldertargetEncoded=foldertarget.gsub('\\','/')
			end

			id = "filelink" + SecureRandom.urlsafe_base64()

			if separate && filefound
				#if we detected a link pointing to a file instead of a folder optionally show a link to the fils and a separate link to the parent folder.
				out << link = link_to(filename, linktarget, :target =>'_blank', :class => 'filelink', :title => id, :name => id, :id => id)
				out << content_tag(:i, '(copy)', :class=>"fa fa-clipboard", :onClick=>"const ta=document.createElement('textarea');ta.value='"+linktextEncoded+"'.replace(/\\//g, '\\\\');document.body.appendChild(ta);ta.select();document.execCommand('copy');document.body.removeChild(ta);")
				out << ' in Verzeichnis '
				out << link = link_to(foldername, foldertarget, :target =>'_blank', :class => 'filelink', :title => id, :name => id, :id => id)
				out << content_tag(:i, '(copy)', :class=>"fa fa-clipboard", :onClick=>"const ta=document.createElement('textarea');ta.value='"+linktextEncoded+"'.replace(/\\//g, '\\\\');document.body.appendChild(ta);ta.select();document.execCommand('copy');document.body.removeChild(ta);")
			else
				out << link = link_to(linktext, linktarget, :target =>'_blank', :class => 'filelink', :title => id, :name => id, :id => id)
				#out << cpbutton.html_safe
				out << content_tag(:i, '(copy)', :class=>"fa fa-clipboard", :onClick=>"const ta=document.createElement('textarea');ta.value='"+linktextEncoded+"'.replace(/\\//g, '\\\\');document.body.appendChild(ta);ta.select();document.execCommand('copy');document.body.removeChild(ta);")
			end
			out
		end
	#Plugin end
	end
end
