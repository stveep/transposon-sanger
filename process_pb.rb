#!/usr/bin/ruby
# Process transposon seqeunces to trim
# Map to mouse using BLAT
# Parse BLAT output

inf = File.open(ARGV[0],'r')
out = File.open(ARGV[0]+'.clip','w')
#Regexp to remove transposon sequence up to TTAA
tag = /^\w+TTCTAGGG/
#Restriction site
site = /GATC\w+/
# Process fasta file
seq = ""
id = 0
record = {}

# This would be much more sensibly done with Bio::FlatFile
while (l=inf.gets)
	#If we are at a new sequence
	if (l.match(/^>/))
		if (id == 0)
			id = l.chomp.sub(/^>/,"")
		end
		next if (seq == "")
		#Process the old one
		#Remove transposon sequence from start
		if seq.match(tag)
			#Sets to start position of the match
			record[id] = [$~.offset(0)[0]]
			seq = seq.sub(tag,"")
		else
			record[id] = ["NA"]
		end
		#Remove stuff after the restriction site
		if seq.match(site)
			record[id].push($~.offset(0)[0])
			seq = seq.sub(site,"GATC")
		else
			record[id].push("NA")
		end
		out.puts ">"+id
		out.puts seq
		seq = ""
		id = l.chomp.sub(/^>/,"")
		else
		seq = seq.to_s+l.chomp	
	end #if >FASTA identifier
	

end # while l

# Need to output the final sequence:
	if seq.match(tag)
		#Sets to start position of the match
		record[id] = [$~.offset(0)[0]]
		seq = seq.sub(tag,"")
	else
		record[id] = ["NA"]
	end
	#Remove stuff after the restriction site
	if seq.match(site)
		record[id].push($~.offset(0)[0])
		seq = seq.sub(site,"GATC")
	else
		record[id].push("NA")
	end
	out.puts ">"+id
	out.puts seq
