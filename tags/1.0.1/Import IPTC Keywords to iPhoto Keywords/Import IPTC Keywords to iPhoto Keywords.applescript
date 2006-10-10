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
property kwIndex : 18


on idle theObject
	set theSel to {}
	try
		with timeout of 900 seconds
			
			tell application "iPhoto"
				set theSel to the selection
			end tell
			
			tell window "status"
				set maximum value of progress indicator "progress" to count of theSel
			end tell
			repeat with theImage in theSel
				set theIPTC to {}
				set theIPTCKeywords to ""
				
				tell application "iPhoto"
					set knownKeywords to the name of every keyword
					set theKeys to the name of every keyword of theImage
					set thePath to the image path of theImage
					select theImage
				end tell
				
				tell window "status"
					set contents of text field "message" to name of theImage
				end tell
				
				tell application "Finder"
					set theAlias to (POSIX file thePath) as alias
				end tell
				
				tell application "GraphicConverter"
					try
						-- get IPTC data without opening image in a window
						set theIPTC to get file iptc of theAlias
					on error
						-- create empty IPTC data list if image doesn't have any
						set theIPTC to {"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""}
					end try
					set theIPTCKeywords to item kwIndex of theIPTC
				end tell
				
				-- theIPTCKeywords may not be defined so we need to handle that using try.
				set savedTextItemDelimiters to AppleScript's text item delimiters
				
				try
					set AppleScript's text item delimiters to {","}
					
					-- check if the keyword is already defined in iPhoto otherwise create it.
					repeat with this_keyword in text items of theIPTCKeywords
						if knownKeywords does not contain this_keyword then
							tell application "iPhoto"
								ka new keyword name this_keyword
							end tell
						end if
						-- check whether the image already has that keyword assigned
						if theKeys does not contain this_keyword then
							tell application "iPhoto"
								assign keyword string this_keyword
							end tell
						end if
					end repeat
					set AppleScript's text item delimiters to savedTextItemDelimiters
				on error m number n from f to t partial result p
					-- also reset text item delimiters in case of an error:
					set AppleScript's text item delimiters to savedTextItemDelimiters
					-- and resignal the error:
					error m number n from f to t partial result p
				end try
				tell window "status"
					tell progress indicator "progress" to increment by 1
				end tell
				
			end repeat
		end timeout
	on error error_message
		tell application "Finder"
			activate
			display dialog error_message buttons {"Cancel"} default button 1 giving up after 120
		end tell
	end try
	quit
end idle

on clicked theObject
	(*Add your script here.*)
end clicked
