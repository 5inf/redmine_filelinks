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
	    This macro provides means for propperly formatting windows file links
	
	    For Chromium based browsers (Google Chorme, Microsoft Edge) you may allow local file access
	      (ideally only restricted to domains you surely trust)
	    	by installing e.g. the "Enable local file links" plugin by "Takashi Sugimoto (tksugimoto)"
	      https://chrome.google.com/webstore/detail/enable-local-file-links/nikfmfgobenbhmocjaaboihbeocackld
	
	    For Firefox
	      http://kb.mozillazine.org/Links_to_local_pages_do_not_work
	      user_pref("capability.policy.policynames", "localfilelinks");
	      user_pref("capability.policy.localfilelinks.sites", "http://www.example1.com http://www.example2.com");
	      user_pref("capability.policy.localfilelinks.checkloaduri.enabled", "allAccess");

	    For Mozilla
	      ...

	  DESCRIPTION

		macro :filelink do |obj, args, text|
			args, options = extract_macro_options(args, :size, :separate)

      separate=false
      if(options[:separate] == 'true')
        separate= true
      end
      filefound = false
      filename= ""
      filetarget=""
      foldername=""
      foldertarget=""

      linktext  = text || "\\\\localhost\\c\\"
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
