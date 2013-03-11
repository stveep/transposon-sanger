#!/usr/bin/ruby
# Parses BLAT PBL parsed output and collects ends together
# Cherry1-PB5-34_B05_0183.ab1     4       -       125618177       1
# Need a single file, with data for both ends.  Set the regular expression below to define how to match PB5 and PB3 ends.
inf = File.open(ARGV[0],'r')
o = File.open(ARGV[1],'w')
# Need to capture plate and well number.  www.rubular.com for regexp help.
pwregexp = /(CM)-\d-(\w+)_/
hash = {}
inf.each do |l|
	(sample,chr,strand,pos,hits,genes) = l.split("\t")
	#Create hash entry unless it already exists
	if sample.match("CM-3")
		pbend = "three"
		sample =~ pwregexp
		key = $1.to_s + $2.to_s	
		puts key
	elsif sample.match("CM-5")
		pbend = "five"
		sample =~ pwregexp
		key = $1.to_s + $2.to_s
	end
#	Strand was taken care of in calculating position
#	if (fs[6] == "-")
#		pos = fs[4].to_i + 1
#	elsif (fs[6] == "+")
#		pos = fs[3].to_i - 4
#	end
	hash[key] ||= {}
#	Genes to be added
	hash[key][pbend] = [chr.to_s,strand,pos.to_s,genes.chomp]
end 

o.puts "Sample\tPB5 chr\tPB5 strand\tPB5 pos\tPB5 gene\tPB3 chr\tPB3 strand\tPB3 pos\tPB3 gene"
hash.each do |k,v|
	v["five"] ||= ["NA","NA","NA","NA"]
	v["three"] ||= ["NA","NA","NA","NA"]
	# Can add a substition for k to strip off annoying filename stuff
	o.puts k + "\t" + v["five"][0]+"\t"+ v["five"][1]+"\t"+ v["five"][2]+"\t"+ v["five"][3]+"\t"+ v["three"][0]+"\t"+ v["three"][1]+"\t"+ v["three"][2]+"\t"+ v["three"][3]
end

