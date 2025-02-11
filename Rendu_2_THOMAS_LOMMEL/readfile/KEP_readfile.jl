"""
    read_kep_file

Contruct G from a `.wmd` file from PrefLib.

# Parameters
* `wmd_file::String` : path of the `.wmd` file.
"""
function read_wmd_file(wmd_file::String)
    isfile(wmd_file) || throw(ArgumentError("$(wmd_file): file not found."))

    # Extract the graph structure from the .wmd file using a MetaGraph
    wmd_io = open(wmd_file, "r")

    # skip the first nine informative lines
    for i in 1:9
        readline(wmd_io)
    end

    # get the number of vertices and edges from the following lines
    splitted_line = split(readline(wmd_io), ' ')
    nb_vertices = parse(Int, splitted_line[4])
    splitted_line = split(readline(wmd_io), ' ')
    nb_edges = parse(Int, splitted_line[4])
    G = MetaDiGraph(nb_vertices, 0)

    # skip next nb_vertices lines, which are onluy informative
    for i in 1:nb_vertices
        readline(wmd_io)
    end
    
    # read the set of edges
    while !eof(wmd_io)
        splitted_line = split(readline(wmd_io), ',')
        # /!\ Pairs are numbered from 0 in the second part of the file
        source = parse(Int, splitted_line[1])
        destination = parse(Int, splitted_line[2])
        weight = parse(Float64, splitted_line[3])

        # do not add an edge that has a zero weight
        if weight > 0
            add_edge!(G, source, destination, :weight, weight)
        end
    end
    return G
end

# Exemple d'utilisation de la fonction supposant que les fichiers sont dans le dossier data
G = read_wmd_file("data_KEP/KEP_001.wmd");
println(G)
println("Number of vertices: ", nv(G))
println("Number of arcs: ", Graphs.ne(G))
println("List of arcs with weights:")
for e in edges(G)
    print("($(e.src),$(e.dst)):$(get_prop(G,e,:weight)), ")
end