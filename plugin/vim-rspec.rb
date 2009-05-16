require "rubygems"
require "hpricot"
require "cgi"

doc		= Hpricot(STDIN.read)
h1			= (doc/"h1")
classes	= {"spec passed"=>"+","spec failed"=>"-","spec not_implemented"=>"#"}

puts "* #{CGI.unescapeHTML h1.inner_html}"

stats = (doc/"script").select {|script| script.innerHTML =~ /duration|totals/ }.map {|script| script.inner_html.scan(/".*"/).first.gsub(/<\/?strong>/,"") }
stats.each do |stat|
	puts "* #{CGI.unescapeHTML stat.gsub(/\"/,'')}"
end
puts "* Parsed with Hpricot (http://wiki.github.com/why/hpricot)"
puts " "

(doc/"div[@class='example_group']").each do |example|
	puts "[#{(example/"dl/dt").inner_html}]"
	(example/"dl/dd").each do |dd|
		txt = (dd/"span:first").inner_html
		puts "#{classes[dd[:class]]} #{CGI.unescapeHTML txt}"
		next if dd[:class]!="spec failed"
		failure  = (dd/"div[@class='failure']")
		msg			= (failure/"div[@class='message']/pre").inner_html
		back		= (failure/"div[@class='backtrace']/pre").inner_html
		ruby		= (failure/"pre[@class='ruby']/code").inner_html.scan(/(<span class="linenum">)(\d+)(<\/span>)(.*)/).map do |elem| 
							"  "+elem[1]+": "+elem[3].gsub(/span/, "").gsub(/class="(\w| )+"/, "").gsub(/<\/>/, "").gsub(/< >/, "") +"\n"
						end.join
		puts "  #{CGI.unescapeHTML msg}"
		puts "  #{CGI.unescapeHTML back}"
		puts   "#{CGI.unescapeHTML ruby}"
	end
	puts " "
end
