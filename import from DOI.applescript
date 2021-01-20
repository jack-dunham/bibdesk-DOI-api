on run {}
	tell application "BibDesk"
		set theDoc to get first document
		log theDoc
		set theDOI to my EnterString("DOI?")
		if theDOI is not "" then
			tell theDoc
				set theOutput to my getFromDOI(theDOI)
				set theBibtex to my trimSpace(theOutput)
				log theBibtex
				set myPub to import from theBibtex
				set selection to myPub
				activate
			end tell
		end if
	end tell
end run

on getFromDOI(theDOI)
	try
		if theDOI contains "https://" then
			set theURL to theDOI
		else
			set theURL to "http://dx.doi.org/" & theDOI
		end if
	end try
	set theBibtex to do shell script "curl -LH \"Accept: text/bibliography; style=bibtex\" " & theURL
	return theBibtex as string
end getFromDOI

on EnterString(promptTxt)
	set theCLIP to the clipboard
	tell application "SystemUIServer"
		set Input to display dialog promptTxt with title "Text Entry" with icon note default answer theCLIP buttons {"Cancel", "OK"} default button 2 giving up after 295
	end tell
	return text returned of Input as string
end EnterString

on trimSpace(theString)
	repeat while theString starts with space
		set theString to text 2 thru -1 of theString as string
	end repeat
end trimSpace