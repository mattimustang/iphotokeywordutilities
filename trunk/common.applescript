(*
Copyright (c) 2005, 2006, Matthew Flanagan
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice, 
       this list of conditions and the following disclaimer.
    
    2. Redistributions in binary form must reproduce the above copyright 
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.

    3. Neither the name of the project nor the names of its contributors may
       be used to endorse or promote products derived from this software
       without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*)
property iptckeywordIndex : 18
property iPhotoVersion : ""
property emptyIPTC : {"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""}

--
-- Return iPhoto major version number
--
on getiPhotoVersion()
	tell application "Finder"
		set iPhotoFullVersion to version of application "iPhoto"
		set savedTextItemDelimiters to AppleScript's text item delimiters
		try
			set AppleScript's text item delimiters to {"."}
			set iPhotoVersion to (the first item of iPhotoFullVersion)
			set AppleScript's text item delimiters to savedTextItemDelimiters
		on error m number n from f to t partial result p
			--also reset text item delimiters in case of an error:
			set AppleScript's text item delimiters to savedTextItemDelimiters
			--and resignal the error:		
			error m number n from f to t partial result p
		end try
	end tell
end getiPhotoVersion

--
-- Return alias, if it exists, given a POSIX
--
on resolveAlias for thePath
	set theAlias to {}
	tell application "Finder"
		try
			set theAlias to (POSIX file thePath) as alias
		on error
			-- do nothing because the file doesn't exist
		end try
	end tell
	return theAlias
end resolveAlias

-- 
-- Return list of aliases to Modified and Original Image
--
on getAllImagePaths for theImagePath
	set theAliasList to {}
	try
		set savedTextItemDelimiters to AppleScript's text item delimiters
		set AppleScript's text item delimiters to {"/"}
		set reversePath to reverse of (text items of theImagePath)
		
		(*
			iPhoto 5 Library layout is:
				YYYY/MM/DD/filename.ext
				YYYY/MM/DD/Originals/filename.ext
			
			iPhoto 6 Library layout is:
				Modified/YYYY/Roll Name/filename.ext
				Originals/YYYY/Roll Name/filename.ext
		*)
		if iPhotoVersion is "5" then
			set theFile to first item of reversePath
			set parentDirectory to rest of reversePath
			set originalPath to {theFile, "Originals"} & parentDirectory
			repeat with thePath in {reversePath, originalPath}
				set newPath to reverse of thePath as text
				set theAliasList to theAliasList & (resolveAlias for newPath)
			end repeat
		else if iPhotoVersion is "6" then
			repeat with theStatus in {"Modified", "Originals"}
				copy reversePath to newPath
				set item 4 of newPath to theStatus as text
				set newPath to reverse of newPath as text
				set theAliasList to theAliasList & (resolveAlias for newPath)
			end repeat
		end if
		set AppleScript's text item delimiters to savedTextItemDelimiters
	on error m number n from f to t partial result p
		--also reset text item delimiters in case of an error:
		set AppleScript's text item delimiters to savedTextItemDelimiters
		--and resignal the error:		
		error m number n from f to t partial result p
	end try
	return theAliasList
end getAllImagePaths
