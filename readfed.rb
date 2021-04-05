# Reading the Federalist Papers
class Fed
    attr_accessor :fedno
    attr_accessor :fedtitle
    attr_accessor :fedpub
    attr_accessor :fedauthor

    # Constructor
    def initialize
      @fedno=0
      @fedtitle
      @fedpub
      @fedauthor
    end

    # Method to print data on one Fed object
    def prt
       puts "Federalist #@fedno"
       puts "#@fedtitle"
       puts "#@fedpub"
       puts "#@fedauthor"
       puts ""
    end
end


# Main program
# Input will come from file fed.txt
file = File.new("fed.txt", "r")
# List of Fed objects 
feds = []

curFed = nil
readstate = "b4Fed"

# Read and process each line
while (line = file.gets)
    line.strip!            # Remove trailing white space
    words = line.split     # Split into array of words

    # "FEDERALIST No. number" starts a new Fed object
    if readstate=="b4Fed" && words[0]=="FEDERALIST" then
       curFed = Fed.new    # Construct new Fed object
       feds << curFed      # Add it to the array
       curFed.fedno = words[2]
       readstate = "b4TitlePub"
       next
    end

    # Title
    if readstate=="b4TitlePub" && !words.empty? then
       curFed.fedtitle = words.join(" ")
       readstate = "inTitlePub"
       next
    end

    # Next lines of Title
    if readstate=="inTitlePub" && !words.empty? && !["For", "From"].include?(words[0]) then
       curFed.fedtitle += " " + words.join(" ")
       next
    end

    # Publisher
    if readstate=="inTitlePub" && ["For", "From"].include?(words[0]) then
       curFed.fedpub = words.join(" ")
       readstate = "b4Author"
       next
    end

    #  Missing Publisher
    if readstate=="inTitlePub" && words.empty? then
       readstate = "b4Author"
       next
    end

    # Authors 
    if readstate=="b4Author" && ["HAMILTON", "JAY", "MADISON"].include?(words[0]) then
       curFed.fedauthor = words.join(" ")
       readstate = "b4Fed"
       next
    end
end   #End of reading



file.close


file_html = File.new("fedindex.html", "w+")
file_html.puts "<html>"
file_html.puts "<head>"
file_html.puts "<title>Federalist Index</title>"
file_html.puts "<style>table, th, td {border: 1px solid black;}</style>"
file_html.puts "</head>"
file_html.puts "<body>"
file_html.puts "<h3>Federalist Index</h3>"
file_html.puts "<table>"
file_html.puts "<tr><th>No.</th><th>Title</th><th>Pub</th><th>Author</th></tr>"
feds.each{|f|  file_html.puts "<tr><td>" + f.fedno.to_s + "</td><td>" + f.fedtitle.to_s + "</td><td>" + f.fedpub.to_s + "</td><td>" + f.fedauthor.to_s + "</td></tr>"}
file_html.puts "</table>"
file_html.puts "</body>"
file_html.puts "</html>"


