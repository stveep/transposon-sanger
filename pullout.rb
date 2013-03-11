#!/usr/bin/ruby
# Get genes from coordinates in .map file (mapped transposon sequences)
inf = File.open(ARGV[0],'r')
out = File.open(ARGV[0]+'.genes','w')


module Steve
def Steve.getgene(chr,pos,finish,species='mus_musculus',version=69)
	require 'rubygems'
	require 'ensembl'
	include Ensembl::Core
	DBConnection.connect(species,version)
	slice = Slice.fetch_by_region('chromosome',chr,pos,finish)
	# true required to get overlapping features rather than completely contained:
	slice.genes(true).map{|a| a.display_name}
end # getgene
end # module
while (l = inf.gets)
	fields = l.split("\t")
	genes = Steve.getgene(fields[1].to_s,fields[3].to_i,fields[3].to_i+3)
	out.puts l.chomp+"\t"+genes.join(",")

end

