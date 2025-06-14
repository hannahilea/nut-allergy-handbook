using Pkg
Pkg.activate(@__DIR__)
using Dates
using CSV
using DataFrames

const SITE_DIR = joinpath(@__DIR__, "..")
const SITE_INDEX_TEMPLATE = joinpath(@__DIR__, "index.template.html")

function get_table_html(df)
    str = """
          <table>
                    <thead>
                        <tr>
                        {{ TABLE_HEAD }}
                        </tr>
                    </thead>
                    <tbody>
                    {{ TABLE_ROWS }}
                    </tbody>
                </table>
                """

    # Table head...
    rows_str = join(["<td>" * v * "</td>\n" for v in names(df)], "")
    str = replace(str, "{{ TABLE_HEAD }}" => rows_str)

    # Table body...
    rows_str = map(eachrow(df)) do entry
        row_str = ["<td>" * v * "</td>\n" for v in values(entry)]
        replace!(row_str, missing => "<td></td>\n")
        return "<tr>\n" * join(row_str, "") * "</tr>\n"
    end
    return str = replace(str, "{{ TABLE_ROWS }}" => join(rows_str, "\n"))
end

function wrap_in_details_block(summary, content)
    return """
           <details><summary>$summary</summary>
               $content
           </details>
           """
end


function generate_index(entries_df; overwrite_existing=false, template=SITE_INDEX_TEMPLATE)
    outfile = joinpath(SITE_DIR, "index.html")
    if !overwrite_existing && isfile(outfile)
        @warn "Output file already exists; not overwriting: $outfile"
        return nothing
    end
    index_str = read(template, String)

    data = select(entries_df,
                  :Classification,
                  Symbol("Name of place") => :Place,
                  Symbol("Google maps link") => ByRow(str -> "<a href=\"$str\">[link]</a>") => :Link,
                  :Comments => ByRow(str -> ismissing(str) ? "" : str) => :Details,
                  Symbol("Timestamp") => ByRow(str -> Dates.format(Date(first(split(str, " ")), dateformat"m/d/yyyy"), dateformat"uu yyyy")) => Symbol("Last checked"))

    out_str = ""
    for gdf in groupby(data, :Classification)
        title = first(gdf.Classification)
        out_str = get_table_html(select(gdf, Not(:Classification)))
        template_key = replace(uppercase(title), " " => "_")
        index_str = replace(index_str, "{{ $template_key }}" => out_str)
        index_str = replace(index_str, "{{ $(template_key)_COUNT }}" => nrow(gdf))
    end
    write(outfile, index_str)

    try
        run(`prettier $(outfile) --write --print-width 360`)
    catch
        @warn "Prettier not installed OR current html errors"
    end

    return nothing
end

# Run from commandline? 
if abspath(PROGRAM_FILE) == @__FILE__
    if "--download" in ARGS
        AIzaSyDjwVcZXpD4Knn9MnrAKuipANdVRu39GAU
    end

    @info "Generating index.html"
    entry_list = CSV.read(joinpath(SITE_DIR, "temp",
                                   "nut-free-mapper - Form Responses 1.csv"), DataFrame)
    # @info entry_list
    generate_index(entry_list; overwrite_existing=true)

    @info "Complete"
    return nothing
end
