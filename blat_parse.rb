#!/usr/bin/ruby
# Parse BLAT output of transposon mapping.
require 'rubygems'
require 'bio'

while (f = ARGV.shift)

inf = Bio::FlatFile.open(Bio::Blat::Report,f)
o = File.open(f+".map",'w')
hash = {}
inf.each do |report|
	# Organise by sequence name
	report.hits.each do |h|
		hash[h.query_def] ||= []
		hash[h.query_def].push(h)
	end #report hits
end # inf.each

hash.each do |id,ha|
	# Get lowest query start, then longest match
	low = []
	lowest = 5000
	# ha = hit array
	ha.each do |h|
		if h.query.start < lowest
			low = [h]
			lowest = h.query.start
		elsif h.query.start == lowest
			low.push(h)
		end
	end # ha.each
	if (low.size > 1)
	long = []
	longest = 0
	low.each do |h|
		if h.match > longest
			long = [h]
			longest = h.match
		elsif h.match == longest
			long.push(h)
		end # if h
	end # low each
	low = long
	end # low size
# Output: if + strand mapping, take target start; if - strand need target end -3 to get Ttaa position (position of proximal T or equivalent base)
	if (low[0].strand == "+")
		o.puts id+"\t"+low[0].target_def.to_s+"\t"+low[0].strand+"\t"+low[0].target.start.to_s+"\t"+low.size.to_s
	else
		pos = low[0].target.end.to_i - 3
		o.puts id+"\t"+low[0].target_def.to_s+"\t"+low[0].strand+"\t"+pos.to_s+"\t"+low.size.to_s
	end #if low
end #hash.each

end # while ..file
